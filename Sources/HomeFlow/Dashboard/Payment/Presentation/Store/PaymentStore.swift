//
//  PaymentStore.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public class PaymentStore: ObservableObject {

  //Dependency
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let lawyerInfoViewModel: LawyerInfoViewModel
  private let orderProcessRepository: OrderProcessRepositoryLogic
  private let paymentRepository: PaymentRepositoryLogic
  private let treatmentRepository: TreatmentRepositoryLogic

  @Published public var isLoading: Bool = false
  @Published public var isPresentVoucherBottomSheet: Bool = false
  @Published public var timeConsultation: String = ""
  @Published public var paymentTimeRemaining: TimeInterval = 0
  @Published public var orderNumberViewModel: OrderNumberViewModel = .init()

  private var treatmentViewModels: [TreatmentViewModel] = []
  private var message: String = ""
  private var userSessionData: UserSessionData?
  public var expiredDateTime: String = ""

  private var subscriptions = Set<AnyCancellable>()

  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    lawyerInfoViewModel: LawyerInfoViewModel,
    orderProcessRepository: OrderProcessRepositoryLogic,
    paymentRepository: PaymentRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.lawyerInfoViewModel = lawyerInfoViewModel
    self.orderProcessRepository = orderProcessRepository
    self.paymentRepository = paymentRepository
    self.treatmentRepository = treatmentRepository

    Task {
      await fetchUserSession()
      await fetchTreatment()
      await requestOrderByNumber()
    }

    observer()
  }

  //MARK: - Fetch API

  @MainActor
  public func requestOrderByNumber() async {
    let headers = HeaderRequest(token: userSessionData?.remoteSession.remoteToken)
    let parameters = OrderNumberParamRequest(orderNumber: lawyerInfoViewModel.orderNumber)
    do {
      let entity = try await paymentRepository.requestOrderByNumber(headers, parameters)
      orderNumberViewModel = OrderNumberEntity.mapTo(entity)
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }

  @MainActor
  private func fetchTreatment() async {
    do {
      let entities = try await treatmentRepository.fetchTreatments()
      getTimeConsultation(from: entities)
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

  private func getTimeConsultation(from entities: [TreatmentEntity]) {
    let type = lawyerInfoViewModel.isProbono ? "PROBONO" : "REGULAR"
    let entity = entities.filter{ $0.type == type }.first!
    timeConsultation = "\(entity.duration) Menit"
  }

  public func getOrderNumber() -> String {
    return String(describing: lawyerInfoViewModel.id)
  }

  public func getAvatarImage() -> URL? {
    return lawyerInfoViewModel.imageURL
  }

  public func getLawyersName() -> String {
    return lawyerInfoViewModel.name
  }

  public func getLawyersPrice() -> String {
    return lawyerInfoViewModel.price
  }

  public func getOriginalPrice() -> String {
    return lawyerInfoViewModel.originalPrice
  }

  public func getAgency() -> String {
    return lawyerInfoViewModel.agency
  }

  public func getTimeRemaining() -> String {
    GLogger(
      .info,
      layer: "Presentation",
      message: orderNumberViewModel
    )

    GLogger(
      .info,
      layer: "Presentation",
      message: orderNumberViewModel.getRemainingMinutes().timeString()
    )

    return orderNumberViewModel.getRemainingMinutes().timeString()
  }

  //MARK: - Indicate

  public func showVoucherBottomSheet() {
    isPresentVoucherBottomSheet = true
  }

  public func hideVoucherBottomSheet() {
    isPresentVoucherBottomSheet = false
  }

  private func indicateLoading() {
    isLoading = true
  }

  private func indicateError(message: String) {
    isLoading = false
  }

  private func indicateError(error: ErrorMessage) {
    isLoading = false
  }

  private func indicateSuccess(message: String) {
    isLoading = false
  }

  private func observer() {


  }

}
