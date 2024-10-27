//
//  OrderProcessStore.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public class OrderProcessStore: ObservableObject {

  //Dependency
  private let advocate: Advocate
  private let sktmModel: ClientGetSKTM?
  private let repository: OrderProcessRepositoryLogic
  private let treatmentRepository: TreatmentRepositoryLogic
  private let paymentNavigator: PaymentNavigator
  private var category: CategoryViewModel
  public var issues: [CategoryViewModel] = []
  private let userSessionDataSource: UserSessionDataSourceLogic

  @Published public var issueText: String = ""
  @Published public var lawyerInfoViewModel: LawyerInfoViewModel = .init()
  @Published public var isPresentBottomSheet: Bool = false
  @Published public var treatmentViewModels: [TreatmentViewModel] = []
  @Published public var isPresentChangeCategoryIssue: Bool = false
  @Published public var timeConsultation: String = ""
  @Published public var issueTextError: String = ""
  @Published public var isTextValid: Bool = false

  private var userSessionData: UserSessionData?
  public var isLoading: Bool = false
  public var message: String = ""

  private var subcriptions = Set<AnyCancellable>()

  public init(
    advocate: Advocate,
    category: CategoryViewModel,
    sktmModel: ClientGetSKTM?,
    userSessionDataSource: UserSessionDataSourceLogic,
    repository: OrderProcessRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic,
    paymentNavigator: PaymentNavigator
  ) {
    self.advocate = advocate
    self.category = category
    self.sktmModel = sktmModel
    self.userSessionDataSource = userSessionDataSource
    self.treatmentRepository = treatmentRepository
    self.repository = repository
    self.paymentNavigator = paymentNavigator

    issues = createIssueCategories()
    setLawyerInfo()

    Task {
      await fetchUserSession()
      await fetchTreatment()
    }

    observer()

  }

  //MARK: - API

  private func requestBookingOrder() async -> BookingOrderEntity? {

    var entity: BookingOrderEntity?

    let bookingOrderParamRequest = BookingOrderParamRequest(
      type: "INSTANT_CONSULTATION",
      lawyerId: lawyerInfoViewModel.id,
      skillId: category.id,
      description: issueText,
      useProbono: lawyerInfoViewModel.isProbono
    )

    do {
      entity = try await repository.requestBookingOrder(
        HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        bookingOrderParamRequest
      )

      return entity

    } catch {
      guard let error = error as? ErrorMessage else {
        return nil
      }

      indicateError(error: error)
    }

    return entity

  }

  private func fetchTreatment() async {
    do {
      let entities = try await treatmentRepository.fetchTreatments()

      Task { @MainActor in
        treatmentViewModels = entities.map(TreatmentEntity.mapTo(_:))
        getTimeConsultation(from: entities)
      }

    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }

  //MARK: - Other function

  private func getTimeConsultation(from entities: [TreatmentEntity]) {
    let type = lawyerInfoViewModel.isProbono ? "PROBONO" : "REGULAR"
    let entity = entities.filter{ $0.type == type }.first!
    timeConsultation = "\(entity.duration) Menit"
  }

  private func fetchUserSession() async {
    do {
      userSessionData = try await userSessionDataSource.fetchData()
    } catch {
      GLogger(
        .info,
        layer: "Presentation",
        message: error
      )
    }
  }

  public func getSelectedCategoryID() -> Int {
    return category.id
  }

  public func setSelected(_ category: CategoryViewModel) {
    self.category = category
  }

  private func createIssueCategories() -> [CategoryViewModel] {
    return advocate.skills.map {
      CategoryViewModel(
        id: $0.id ?? 0,
        name: $0.name ?? ""
      )
    }
  }

  public func getIssueName() -> String {
    return category.name
  }

  public func setLawyerInfo() {
    var sktmQuota: Int = 0

    if let quota = sktmModel?.data?.quota, quota > 0  {
      sktmQuota = quota
    }

    lawyerInfoViewModel = LawyerInfoViewModel(
      id: advocate.id ?? 0,
      imageURL: advocate.getImageName(),
      name: advocate.getName(),
      agency: advocate.agency_name ?? "",
      price: advocate.getPrice(),
      originalPrice: advocate.getOriginalPrice(),
      isDiscount: advocate.isDiscount,
      isProbono: sktmQuota > 0,
      orderNumber: ""
    )
  }

  public func showChangeCategory() {
    isPresentChangeCategoryIssue = true
  }

  public func dismissChangeCategory() {
    isPresentChangeCategoryIssue = false
  }

  public func getPrice() -> String {
    return lawyerInfoViewModel.price
  }

  //MARK: - Navigator

  @MainActor
  public func navigateToPayment() {
    hideOrderInfoBottomSheet()

    Task {
      let entity = await requestBookingOrder()
      guard let orderNumber = entity?.orderNumber else { return }
      lawyerInfoViewModel.setOrderNumber(orderNumber)
      paymentNavigator.navigateToPayment(lawyerInfoViewModel)
    }

  }

  public func navigateToRequestProbono() {

  }

  //MARK: - Indicate

  public func showOrderInfoBottomSheet() {
    isPresentBottomSheet = true
  }

  private func hideOrderInfoBottomSheet() {
    isPresentBottomSheet = false
  }

  private func indicateLoading() {
    isLoading = true
  }

  private func indicateError(message: String) {
    isLoading = false
    self.message = message
  }

  private func indicateError(error: ErrorMessage) {
    isLoading = false
  }

  private func indicateSuccess(message: String) {
    isLoading = false
  }

  //MARK: - Observer

  public func isValidText(_ text: String) -> AnyPublisher<Bool, Never> {
    return Future<Bool, Never> { promise in
      promise(.success(text.count > 10))
    }.eraseToAnyPublisher()
  }

  private func observer() {
    $issueText
      .dropFirst()
      .flatMap { self.isValidText($0) }
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        self.isTextValid = state
        self.issueTextError = state ? "Minimal 10 Karakter" : ""
      }.store(in: &subcriptions)

  }

}

public protocol OrderProcessStoreFactory {
  func makeOrderProcessStore() -> OrderProcessStore
}
