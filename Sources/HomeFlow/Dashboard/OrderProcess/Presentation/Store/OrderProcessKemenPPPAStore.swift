//
//  OrderProcessKemenPPPAStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class OrderProcessKemenPPPAStore: OrderProcessStore {
  
  private let kemenPPPARepository: KemenPPPARepositoryLogic
  private let waitingRoomNavigator: WaitingRoomNavigator
  
  @Published public var isPresentReasonToContinue: Bool = false
  @Published public var isPresentViolenceBottomSheet: Bool = false
  @Published public var isPresentPrivacyKemenPPPA: Bool = false
  @Published public var didNotHaveIdentity: Bool = false
  @Published public var incident: String = ""
  @Published public var identityNumber: String = ""
  @Published public var violenceErrorMessage: String = ""
  @Published public var applicantErrorMessage: String = ""
  @Published public var incidentErrorMessage: String = ""
  @Published public var identityNumberErrorMessage: String = ""
  @Published public var htmlText: String = ""
  @Published public var selectedApplicant: ApplicantEntity?
  @Published public var selectedViolence: ViolenceCategoryEntity?
  @Published public var violences: [ViolenceCategoryEntity] = []
  @Published public var applicantOptions: [ApplicantEntity] = []
  @Published public var reasonsKemenPPPA: [ReasonEntity] = []
  @Published public var selectedReason: ReasonEntity?
  
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
    paymentNavigator: PaymentNavigator,
    sktmNavigator: SKTMNavigator,
    probonoNavigator: ProbonoNavigator,
    aiRepository: AIRepositoryLogic,
    advocateNavigator: OnlineAdvocateNavigator,
    waitingRoomNavigator: WaitingRoomNavigator
  ) {
    
    self.kemenPPPARepository = kemenPPPARepository
    self.waitingRoomNavigator = waitingRoomNavigator
    
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
      violences = try await kemenPPPARepository.fetchCategories()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
    
  }
  
  @MainActor
  public func fetchReasonKemenPPPA() async {
    do {
      reasonsKemenPPPA = try await kemenPPPARepository.fetchReasonsKemenPPPA()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  @MainActor
  public func requestToProcessKemenPPPA() async {
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
    
    if !didNotHaveIdentity && identityNumber.isEmpty {
      identityNumberErrorMessage = "NIK harus diisi"
    }
    
    if incident.isEmpty {
      incidentErrorMessage = "Lokasi kejadian harus diisi"
    }
    
    if descriptions.isEmpty || selectedViolence == nil
        || selectedApplicant == nil || identityNumber.isEmpty
        || incident.isEmpty {
      
      buttonActive = false
      return
    }
    
    isPresentPrivacyKemenPPPA = true
    
  }
  
  @MainActor
  public func fetchPrivacyPolicyKemenPPPA() async {
    do {
      htmlText = try await kemenPPPARepository.fetchPrivacyPolicyKemenPPPA()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error)
    }
  }
  
  //MARK: - Other Function
  
  
  
  //MARK: - Navigator
  
  public func navigateToWaitingRoom() {
    waitingRoomNavigator.navigateToWaitingRoom(userCases: .init(), roomKey: "")
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
  }
  
  public override func observer() {
    super.observer()
    
    $selectedViolence
      .sink { [weak self] _ in
        self?.buttonActive = true
      }.store(in: &subscriptions)
    
    $selectedApplicant
      .sink { [weak self] _ in
        self?.buttonActive = true
      }.store(in: &subscriptions)
    
    $identityNumber
      .sink { [weak self] _ in
        self?.buttonActive = true
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
