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
  private let waitingRoomNavigator: WaitingRoomNavigator
  
  @Published public var isLoading: Bool = false
  @Published public var isPresentVoucherBottomSheet: Bool = false
  @Published public var timeConsultation: String = ""
  @Published public var paymentTimeRemaining: TimeInterval = 300
  @Published public var orderViewModel: OrderViewModel = .init()
  @Published public var activateButton: Bool = false
  @Published public var voucherCode: String = ""
  @Published public var showXMark: Bool = false
  @Published public var voucherErrorText: String = ""
  @Published public var voucherViewModel: VoucherViewModel = .init()
  @Published public var voucherFilled: Bool = false
  @Published public var isPresentTncBottomSheet: Bool = false
  
  private var treatmentViewModels: [TreatmentViewModel] = []
  private var message: String = ""
  private var userSessionData: UserSessionData?
  private var paymentEntity: PaymentEntity = .init()
  public var expiredDateTime: String = ""
  
  public let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init() {
    self.userSessionDataSource = MockUserSessionDataSource()
    self.lawyerInfoViewModel = .init()
    self.orderProcessRepository = MockOrderProcessRepository()
    self.paymentRepository = MockPaymentRepository()
    self.treatmentRepository = MockTreatmentRepository()
    self.waitingRoomNavigator = MockNavigator()
  }
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    lawyerInfoViewModel: LawyerInfoViewModel,
    orderProcessRepository: OrderProcessRepositoryLogic,
    paymentRepository: PaymentRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic,
    waitingRoomNavigator: WaitingRoomNavigator
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.lawyerInfoViewModel = lawyerInfoViewModel
    self.orderProcessRepository = orderProcessRepository
    self.paymentRepository = paymentRepository
    self.treatmentRepository = treatmentRepository
    self.waitingRoomNavigator = waitingRoomNavigator
    
    Task {
      await fetchUserSession()
      await fetchTreatment()
      await requestOrderByNumber()
    }
    
    observer()
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func applyVoucher() async {
    voucherViewModel = await requestVoucher()
    if voucherViewModel.success {
      voucherFilled = true
      await requestOrderByNumber()
    }
  }
  
  @MainActor
  public func removeVoucher() async {
    let success = await requestRemoveVoucher()
    if success {
      voucherFilled = false
      await requestOrderByNumber()
    }
  }
  
  @MainActor
  public func requestOrderByNumber() async {
    let headers = HeaderRequest(token: userSessionData?.remoteSession.remoteToken)
    let parameters = OrderNumberParamRequest(
      orderNumber: lawyerInfoViewModel.orderNumber,
      voucherCode: voucherViewModel.code
    )
    
    do {
      let entity = try await paymentRepository.requestOrderByNumber(headers, parameters)
      orderViewModel = OrderEntity.mapTo(entity)
      paymentTimeRemaining = orderViewModel.getRemainingMinutes()
      
      indicateSuccess()
      hideVoucherBottomSheet()
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
  
  @MainActor
  private func requestVoucher() async -> VoucherViewModel {
    var viewModel: VoucherViewModel = .init()
    
    do {
      let entity = try await paymentRepository.requestUseVoucher(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: VoucherParamRequest(
          orderNumber: lawyerInfoViewModel.orderNumber,
          voucherCode: voucherCode
        )
      )
      
      viewModel = VoucherEntity.mapTo(entity)
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else { return .init() }
      voucherError(error)
    }
    
    return viewModel
  }
  
  @MainActor
  private func requestRemoveVoucher() async -> Bool {
    var succeeded: Bool = false
    
    do {
      succeeded = try await paymentRepository.requestRemoveVoucher(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: VoucherParamRequest(
          orderNumber: lawyerInfoViewModel.orderNumber,
          voucherCode: voucherCode
        )
      )
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else {
        return false
      }
      
      indicateError(error: error)
    }
    
    return succeeded
  }
  
  @MainActor
  public func requestCreatePayment() async {
    do {
      paymentEntity = try await paymentRepository.requestCreatePayment(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: PaymentParamRequest(
          orderNumber: lawyerInfoViewModel.orderNumber,
          consultationGuideAnswerId: 2,
          voucherCode: voucherCode
        )
      )
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  //MARK: - Other function
  
  public func getVoucherText() -> String {
    return "Hemat \(voucherViewModel.amount)"
  }
  
  public func getVoucherDuration() -> String {
    return "Durasi konsultasi akan selama \(voucherViewModel.duration) menit"
  }
  
  public func isProbono() -> Bool {
    return lawyerInfoViewModel.isProbono
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
  
  private func getTimeConsultation(from entities: [TreatmentEntity]) {
    let type = lawyerInfoViewModel.isProbono ? "PROBONO" : "REGULAR"
    let entity = entities.filter{ $0.type == type }.first!
    timeConsultation = "\(entity.duration) Menit"
  }
  
  public func getOrderNumber() -> String {
    return String(describing: lawyerInfoViewModel.orderNumber)
  }
  
  public func getAvatarImage() -> URL? {
    return lawyerInfoViewModel.imageURL
  }
  
  public func getLawyersName() -> String {
    return lawyerInfoViewModel.name
  }
  
  public func getAgency() -> String {
    return lawyerInfoViewModel.agency
  }
  
  public func getExpiredDate() -> String {
    return "Bayar sebelum \(orderViewModel.expiredDate())"
  }
  
  public func getTimeRemaining() -> String {
    if orderViewModel.expiredAt == 0 {
      return "00:00"
    }
    
    return orderViewModel.getRemainingMinutes().timeString()
  }
  
  public func getPaymentDetails() -> [FeeViewModel] {
    var items: [FeeViewModel] = []
    if let voucher = orderViewModel.voucher {
      items.append(voucher)
    }
    items.append(orderViewModel.lawyerFee)
    items.append(orderViewModel.adminFee)
    items.append(orderViewModel.discount)
    return items.sorted(by: {$0.id < $1.id})
  }
  
  private func getLawyerFee() -> (String, String) {
    return (
      orderViewModel.lawyerFee.name,
      orderViewModel.lawyerFee.amount
    )
  }
  
  private func getAdminFee() -> (String, String) {
    return (
      orderViewModel.adminFee.name,
      orderViewModel.adminFee.amount
    )
  }
  
  private func getDiscount() -> (String, String) {
    return (
      orderViewModel.discount.name,
      orderViewModel.discount.amount
    )
  }
  
  public func getTotalAmount() -> String {
    if isProbono() {
      return "Gratis"
    }
    return orderViewModel.totalAmount
  }
  
  public func getTotalAdjustment() -> String {
    return "Anda hemat \(orderViewModel.totalAdjustment) di transaksi ini!"
  }
  
  public func getTNCVoucher() -> String {
    return voucherViewModel.tnc
  }
  
  public func receiveTimer() {
    if paymentTimeRemaining > 0 {
      paymentTimeRemaining -= 1
    } else {
      paymentTimeRemaining = 0
      timer.upstream.connect().cancel()
    }
  }
  
  //MARK: - Navigator
  
  public func navigateToWaitingRoom() {
    Task {
      await requestCreatePayment()
      waitingRoomNavigator.navigateToWaitingRoom(
        roomKey: paymentEntity.roomKey,
        consultationID: orderViewModel.consultationID
      )
    }
   
  }
  
  //MARK: - Indicate
  
  public func showVoucherBottomSheet() {
    isPresentVoucherBottomSheet = true
  }
  
  public func hideVoucherBottomSheet() {
    isPresentVoucherBottomSheet = false
  }
  
  public func showTNCBottomSheet() {
    isPresentTncBottomSheet = true
  }
  
  public func hideTNCBottomSheet() {
    isPresentTncBottomSheet = false
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
  
  private func indicateSuccess() {
    isLoading = false
    voucherErrorText = ""
  }
  
  private func voucherError(_ error: ErrorMessage) {
    guard let message = error.payload["message"] as? String else {
      voucherErrorText = error.message
      return
    }
    
    voucherErrorText = message
  }
  
  //MARK: - Observer
  
  private func observer() {
    $voucherCode
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { text in
        self.activateButton = !text.isEmpty
        self.showXMark = !text.isEmpty
      }.store(in: &subscriptions)
  }
  
}
