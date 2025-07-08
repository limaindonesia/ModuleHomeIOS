//
//  OrderProcessKemenPPPAStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public class OrderProcessKemenPPPAStore: OrderProcessStore {
  
  private let kemenPPPARepository: KemenPPPARepositoryLogic
  private let ongoingRepository: OngoingRepositoryLogic
  private let detailAdvocateRepository: DetailAdvocateRepositoryLogic
  private let waitingRoomNavigator: WaitingRoomNavigator
  
  @Published public var isPresentReasonToContinue: Bool = false
  @Published public var isPresentViolenceBottomSheet: Bool = false
  @Published public var isPresentPrivacyKemenPPPA: Bool = false
  @Published public var isPresentDetailAdvocate: Bool = false
  @Published public var didNotHaveIdentity: Bool = false
  @Published public var incident: String = ""
  @Published public var identityNumber: String = ""
  @Published public var violenceErrorMessage: String = ""
  @Published public var applicantErrorMessage: String = ""
  @Published public var incidentErrorMessage: String = ""
  @Published public var identityNumberErrorMessage: String = ""
  @Published public var reasonErrorMessage: String = ""
  @Published public var htmlText: String = ""
  @Published public var selectedApplicant: ApplicantEntity?
  @Published public var selectedViolence: ViolenceCategoryEntity?
  @Published public var violences: [ViolenceCategoryEntity] = []
  @Published public var applicantOptions: [ApplicantEntity] = []
  @Published public var reasonsKemenPPPA: [ReasonEntity] = []
  @Published public var selectedReason: ReasonEntity?
  @Published public var reasonToContinueText: String = ""
  
  public var userCase: UserCases = .init()
  public var reviews: LawyerReviewList = .init()
  public var totalReview: Int = 0
  
  public init(
    advocate: Advocate,
    selectedPriceCategories: PriceCategoryViewModel,
    sktmModel: ClientGetSKTM?,
    userSessionDataSource: UserSessionDataSourceLogic,
    kemenPPPARepository: KemenPPPARepositoryLogic,
    repository: OrderProcessRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic,
    orderServiceRepository: OrderServiceRepositoryLogic,
    probonoRepository: GetKTPDataRepositoryLogic,
    ongoingRepository: OngoingRepositoryLogic,
    detailAdvocateRepository: DetailAdvocateRepositoryLogic,
    paymentNavigator: PaymentNavigator,
    sktmNavigator: SKTMNavigator,
    probonoNavigator: ProbonoNavigator,
    aiRepository: AIRepositoryLogic,
    advocateNavigator: OnlineAdvocateNavigator,
    waitingRoomNavigator: WaitingRoomNavigator
  ) {
    
    self.kemenPPPARepository = kemenPPPARepository
    self.waitingRoomNavigator = waitingRoomNavigator
    self.ongoingRepository = ongoingRepository
    self.detailAdvocateRepository = detailAdvocateRepository
    
    super.init(
      advocate: advocate,
      selectedPriceCategories: selectedPriceCategories,
      sktmModel: sktmModel,
      userSessionDataSource: userSessionDataSource,
      repository: repository,
      treatmentRepository: treatmentRepository,
      orderServiceRepository: orderServiceRepository,
      probonoRepository: probonoRepository,
      paymentNavigator: paymentNavigator,
      sktmNavigator: sktmNavigator,
      probonoNavigator: probonoNavigator,
      aiRepository: aiRepository,
      advocateNavigator: advocateNavigator
    )
    
  }
  
  public var showReasonField: Bool {
    return !reasonsKemenPPPA.isEmpty
  }
  
  //MARK: - API
  
  @MainActor
  public func fetchKemenPPPACategory() async {
    do {
      let token = userSessionData?.remoteSession.remoteToken
      violences = try await kemenPPPARepository.fetchCategories(headers: HeaderRequest(token: token))
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
    
  }
  
  @MainActor
  public func fetchReasonKemenPPPA() async {
    do {
      let token = userSessionData?.remoteSession.remoteToken
      reasonsKemenPPPA = try await kemenPPPARepository.fetchReasonsKemenPPPA(headers: HeaderRequest(token: token))
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  @MainActor
  public func fetchPrivacyPolicyKemenPPPA() async {
    do {
      let token = userSessionData?.remoteSession.remoteToken
      htmlText = try await kemenPPPARepository.fetchPrivacyPolicyKemenPPPA(headers: HeaderRequest(token: token))
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  public func requestToProcessKemenPPPA() {
    descriptionErrorMessage = ""
    violenceErrorMessage = ""
    applicantErrorMessage = ""
    identityNumberErrorMessage = ""
    incidentErrorMessage = ""
    
    if descriptions.detectSentences().count < 10 {
      descriptionErrorColor = .danger500
    }
    
    if selectedViolence == nil {
      violenceErrorMessage = "Jenis kekerasan harus diisi"
    }
    
    if selectedApplicant == nil {
      applicantErrorMessage = "Posisi pemohon harus diisi"
    }
    
    if selectedReason == nil {
      reasonErrorMessage = "Alasan konsultasi lanjutan harus diisi"
    }
    
    if !didNotHaveIdentity && identityNumber.isEmpty {
      identityNumberErrorMessage = "NIK harus diisi"
    } else if !didNotHaveIdentity && !identityNumber.isValidNumber() {
      identityNumberErrorMessage = "Harus berupa angka"
    } else if !didNotHaveIdentity && identityNumber.count < 16 {
      identityNumberErrorMessage = "Minimal 16 digit"
    }
    
    if incident.isEmpty {
      incidentErrorMessage = "Lokasi kejadian harus diisi"
    }
    
    if didNotHaveIdentity {
      checkWithoutIdentity()
    } else {
      checkWithIdentity()
    }
    
  }
  
  @MainActor
  public func createConsultation() async {
    let consultation = KemenPPPAParamRequest.Consultation(
      orderType: "KEMENPPPA",
      lawyerID: lawyerInfoViewModel.id,
      skillID: advocate.detail.first??.skill_id ?? 0,
      description: descriptions
    )
    
    let form = KemenPPPAParamRequest.Form(
      reasonFollowUpConsultation: selectedReason?.title,
      relation: selectedApplicant!.title,
      identifier: didNotHaveIdentity ? "" : identityNumber,
      caseLocation: incident
    )
    
    let kemenPPPAParamRequest = KemenPPPAParamRequest(
      type: "INSTANT_CONSULTATION",
      consultation: consultation,
      form: form
    )
    
    do {
      let token = userSessionData?.remoteSession.remoteToken
      let roomKey = try await kemenPPPARepository.requestCreateConsultationKemenPPPA(
        headers: HeaderRequest(token: token),
        params: kemenPPPAParamRequest
      )
      
      await requestOngoingUserCases()
      navigateToWaitingRoom(roomKey)
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
    
  }
  
  @MainActor
  public func requestOngoingUserCases() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let entities = try await ongoingRepository.fetchOngoingUserCases(
        headers: HeaderRequest(token: token).toHeaders(),
        parameters: UserCasesParamRequest(type: .ONGOING)
      )
      if entities.count > 0 {
        userCase = entities[0]
      }
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  @MainActor
  public func getLawyerReview() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let response = try await detailAdvocateRepository.getLawyerReview(
        headers: HeaderRequest(token: token),
        parameters: ReviewParamRequest(
          lawyerID: advocate.id ?? 0,
          limit: 3,
          page: 1
        )
      )
      
      guard let data = response.data else { return }
      reviews = data
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  @MainActor
  public func getLawyerRating() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let response = try await detailAdvocateRepository.getLawyerRating(
        headers: HeaderRequest(token: token),
        parameters: ReviewParamRequest(
          lawyerID: advocate.id ?? 0,
          limit: 0,
          page: 0
        )
      )
      
      guard let data = response.data else { return }
      totalReview = data.total_review ?? 0
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  //MARK: - Other Function
  
  private func checkWithIdentity() {
    if descriptions.isEmpty || selectedViolence == nil || selectedApplicant == nil
        || identityNumber.isEmpty || identityNumber.count < 16
        || !identityNumber.isValidNumber() || incident.isEmpty {
      buttonActive = false
      return
    }
    
    isPresentPrivacyKemenPPPA = true
  }
  
  private func checkWithoutIdentity() {
    if descriptions.isEmpty || selectedViolence == nil
        || selectedApplicant == nil || incident.isEmpty {
      buttonActive = false
      return
    }
    isPresentPrivacyKemenPPPA = true
  }
  
  
  //MARK: - Navigator
  
  public func navigateToWaitingRoom(_ roomKey: String) {
    waitingRoomNavigator.navigateToWaitingRoom(
      userCases: userCase,
      roomKey: roomKey
    )
  }
  
  public func navigateToAdvocateDetailReview() {
    advocateNavigator.navigateToDetailReview(advocate)
  }
  
  //MARK: - Indicate
  
  public func indicateLoading() {
    isLoading = true
  }
  
  public func indicateSuccess() {
    isLoading = false
  }
  
  public func indicateError(_ error: ErrorMessage) {
    isLoading = false
    self.error = error
  }
  
  public override func observer() {
    super.observer()
    
    $didNotHaveIdentity
      .sink { [weak self] state in
        if state {
          self?.identityNumber = ""
        }
      }.store(in: &subscriptions)
    
    $selectedReason
      .sink { [weak self] _ in
        self?.buttonActive = true
        self?.reasonErrorMessage = ""
      }.store(in: &subscriptions)
    
    $selectedViolence
      .sink { [weak self] _ in
        self?.buttonActive = true
        self?.violenceErrorMessage = ""
      }.store(in: &subscriptions)
    
    $selectedApplicant
      .sink { [weak self] _ in
        self?.buttonActive = true
        self?.applicantErrorMessage = ""
      }.store(in: &subscriptions)
    
    $identityNumber
      .sink { [weak self] _ in
        self?.buttonActive = true
        self?.identityNumberErrorMessage = ""
      }.store(in: &subscriptions)
    
    $incident
      .sink { [weak self] _ in
        self?.incidentErrorMessage = ""
        self?.buttonActive = true
      }.store(in: &subscriptions)
  }
  
}

public protocol OrderProcessKemenPPPAStoreFactory {
  func makeOrderProcessKemenPPPAStore(
    advocate: Advocate,
    selectedPriceCategory: PriceCategoryViewModel
  ) -> OrderProcessKemenPPPAStore
}
