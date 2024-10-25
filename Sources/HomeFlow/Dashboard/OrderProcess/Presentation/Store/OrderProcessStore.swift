//
//  OrderProcessStore.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

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
  @Published public var categoryViewModel: CategoryViewModel = .init()
  @Published public var isPresentBottomSheet: Bool = false
  @Published public var isLoading: Bool = false
  @Published public var message: String = ""
  @Published public var treatmentViewModels: [TreatmentViewModel] = []
  @Published public var isPresentChangeCategoryIssue: Bool = false

  private var userSessionData: UserSessionData?

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

    setLawyerInfo()
    issues = createIssueCategories()

    Task {
      await fetchUserSession()
      await fetchTreatment()
    }

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
      let entity = try await treatmentRepository.fetchTreatments()
      treatmentViewModels = entity.map(TreatmentEntity.mapTo(_:))
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }

  //MARK: - Other function

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
    var time: TimeInterval = 45
    var sktmQuota: Int = 0

    if let quota = sktmModel?.data?.quota, quota > 0  {
      time = 30
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
      timeRemainig: time,
      orderNumber: ""
    )
  }

  public func showChangeCategory() {
    isPresentChangeCategoryIssue = true
  }

  public func dismissChangeCategory() {
    isPresentChangeCategoryIssue = false
  }

  //MARK: - Navigator

  public func navigateToPayment() {
    hideOrderInfoBottomSheet()

    Task {
      let entity = await requestBookingOrder()
      guard let orderNumber = entity?.orderNumber else { return }
      lawyerInfoViewModel.setOrderNumber(orderNumber)
    }

//    paymentNavigator.navigateToPayment(lawyerInfoViewModel)
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

}

public protocol OrderProcessStoreFactory {
  func makeOrderProcessStore() -> OrderProcessStore
}
