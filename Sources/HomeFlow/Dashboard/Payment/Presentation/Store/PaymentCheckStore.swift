//
//  PaymentCheckStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import GnDKit
import AprodhitKit
import Combine

public class PaymentCheckStore: ObservableObject {
  
  //Dependency
  public let lawyerInfo: LawyerInfoViewModel
  private var paymentURL: URL?
  private let price: String
  private let roomKey: String
  private let consultationID: Int
  private let orderID: String
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let cancelationRepository: PaymentCancelationRepositoryLogic
  private let paymentCheckRepository: PaymentCheckRepositoryLogic
  private let dashboardResponder: DashboardResponder
  private let paymentNavigator: PaymentNavigator
  private let waitingRoomNavigator: WaitingRoomNavigator
  
  public var paymentTimeRemaining: CurrentValueSubject<TimeInterval, Never> = .init(0)
  @Published public var showTimeRemainig: Bool = false
  @Published public var isLoading: Bool = false
  @Published public var isPresentReasonBottomSheet: Bool = false
  @Published public var reasons: [ReasonEntity] = []
  @Published public var showErrorMessage: Bool = false
  @Published public var errorMessage: ErrorMessage = .init()
  
  public var userCase: UserCases? = nil
  public var selectedReason: ReasonEntity? = nil
  public var reason: String? = nil
  private var userSessionData: UserSessionData?
  private var paymentStatus: PaymentStatusViewModel = .init()
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init() {
    self.userSessionDataSource = MockUserSessionDataSource()
    self.cancelationRepository = MockPaymentCancelationRepository()
    self.paymentCheckRepository = MockPaymentCheckRepository()
    self.dashboardResponder = MockNavigator()
    self.paymentNavigator = MockNavigator()
    self.waitingRoomNavigator = MockNavigator()
    
    self.price = ""
    self.paymentURL = nil
    self.roomKey = ""
    self.consultationID = 0
    self.orderID = ""
    self.lawyerInfo = .init()
    
    Task {
      await requestReasons()
    }
  }
  
  public init(
    lawyerInfo: LawyerInfoViewModel,
    price: String,
    paymentURL: URL?,
    roomKey: String,
    consultationID: Int,
    orderID: String,
    userSessionDataSource: UserSessionDataSourceLogic,
    cancelationRepository: PaymentCancelationRepositoryLogic,
    paymentCheckRepository: PaymentCheckRepositoryLogic,
    dashboardResponder: DashboardResponder,
    paymentNavigator: PaymentNavigator,
    waitingRoomNavigator: WaitingRoomNavigator
  ) {
    self.lawyerInfo = lawyerInfo
    self.price = price
    self.paymentURL = paymentURL
    self.roomKey = roomKey
    self.consultationID = consultationID
    self.orderID = orderID
    self.userSessionDataSource = userSessionDataSource
    self.cancelationRepository = cancelationRepository
    self.dashboardResponder = dashboardResponder
    self.paymentNavigator = paymentNavigator
    self.paymentCheckRepository = paymentCheckRepository
    self.waitingRoomNavigator = waitingRoomNavigator
    
    Task {
      await fetchUserSession()
      await requestReasons()
      await requestUserCases()
      await calculateTimeRemaining()
    }
    
    observer()
  }
  
  //MARK: - Fetch Local Data
  
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
  
  //MARK: Request API
  
  @MainActor
  public func requestCancelation() async {
    if paymentTimeRemaining.value <= 0 {
      let success = await sendCancelationReason()
      if success {
        isPresentReasonBottomSheet = false
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        backToHome()
      }
    } else {
      let success = await requestCancelationPayment()
      if success {
        isPresentReasonBottomSheet = false
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        backToHome()
      }
    }
  }
  
  public func requestUserCases() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let entities = try await paymentCheckRepository.fetchOngoingUserCases(
        headers: HeaderRequest(token: token).toHeaders(),
        parameters: UserCasesParamRequest(type: "ongoing")
      )
      
      userCase = entities[0]
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func requestReasons() async {
    do {
      reasons = try await cancelationRepository.requestReasons(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken)
      )
      indicateSuccess()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  private func requestCancelationPayment() async -> Bool {
    indicateLoading()
    var success: Bool = false
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return false
      }
      
      success = try await cancelationRepository.requestPaymentCancel(
        headers: HeaderRequest(token: token),
        parameters: CancelPaymentRequest(
          orderNumber: getOrderNumber(),
          reasonID: selectedReason?.id ?? 0,
          reason: selectedReason?.title == "Lainnya" ? reason : selectedReason?.title
        )
      )
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else { return false }
      indicateError(error: error)
    }
    
    return success
  }
  
  @MainActor
  private func sendCancelationReason() async -> Bool {
    indicateLoading()
    var success: Bool = false
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return false
      }
      success = try await cancelationRepository.requestCancelReason(
        headers: HeaderRequest(token: token),
        parameters: CancelPaymentRequest(
          orderNumber: getOrderNumber(),
          reasonID: selectedReason?.id ?? 0,
          reason: selectedReason?.title == "Lainnya" ? reason : selectedReason?.title
        )
      )
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else {
        return false
      }
      indicateError(error: error)
    }
    
    return success
  }
  
  @MainActor
  public func dismissReason() async -> Bool {
    indicateLoading()
    var success: Bool = false
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        indicateError(message: "")
        return false
      }
      
      success = try await cancelationRepository.requestCancelReason(
        headers: HeaderRequest(token: token),
        parameters: .init(dismiss: true)
      )
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else {
        return false
      }
      indicateError(error: error)
    }
    
    return success
  }
  
  @MainActor
  public func requestPaymentStatus() async {
    indicateLoading()
    
    guard let data = userSessionData else {
      return
    }
    
    do {
      let entity = try await paymentCheckRepository.requestPaymentStatus(
        headers: HeaderRequest(token: data.remoteSession.remoteToken),
        parameters: .init(orderNumber: userCase?.order_no ?? "")
      )
      
      paymentStatus = PaymentStatusEntity.mapTo(entity)
      checkStatus(from: paymentStatus)
      
      indicateSuccess()
      
    } catch {
      if let error = error as? ErrorMessage {
        indicateError(error: error)
      }
    }
  }
  
  //MARK: - Other Function
  
  @MainActor
  public func onDismissedReasonBottomSheet() async {
    if paymentTimeRemaining.value <= 0 {
      let success = await dismissReason()
      if success {
        isPresentReasonBottomSheet = false
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        backToHome()
      }
    }
    
    hideReasonBottomSheet()
  }
  
  public func getOrderNumber() -> String {
    return String(describing: userCase?.order_no ?? "")
  }
  
  public func getRemainingMinutes(_ expiredAt: Int) -> TimeInterval {
    let interval = Double(expiredAt)
    let date = interval.epochToDate()
    let timeRemaining = Date().findMinutesDiff(with: date)
    return timeRemaining
  }
  
  @MainActor
  private func calculateTimeRemaining() {
    guard let expired = userCase?.payment_expired_at else { return }
    guard let expDate = expired.toDate() else { return }
    let timeRemaining = Date().findMinutesDiff(with: expDate)
    paymentTimeRemaining.value = timeRemaining
    showTimeRemainig = true
  }
  
  public func getTimeRemaining() -> String {
    if paymentTimeRemaining.value == 0 {
      return "00:00"
    }
    
    return paymentTimeRemaining.value.timeString()
  }
  
  private func checkStatus(from viewModel: PaymentStatusViewModel) {
    if viewModel.status == Constant.Text.COMPLETE {
      guard let userCase = userCase else { return }
      waitingRoomNavigator.navigateToWaitingRoom(
        userCase: userCase,
        roomKey: roomKey
      )
      
      return
    }
    
    if viewModel.status == Constant.Text.PENDING {
      indicateError(message: "Payment Pending")
      return
    }
    
    if viewModel.status == Constant.Text.PROCESSED {
      indicateError(message: "Tolong selesaikan pembayaran")
      return
    }
    
  }
  
  private func observer() {
    paymentTimeRemaining
      .dropFirst()
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { value in
        if value <= 0 {
          self.showReasonBottomSheet()
        }
      }
      .store(in: &subscriptions)
  }
  
  //MARK: - Indicate
  
  private func indicateLoading() {
    isLoading = true
  }
  
  private func indicateError(message: String) {
    isLoading = false
    showErrorMessage = true
    errorMessage = .init(title: "Gagal", message: message)
  }
  
  private func indicateError(error: ErrorMessage) {
    isLoading = false
    showErrorMessage = true
    errorMessage = error
  }
  
  private func indicateSuccess() {
    isLoading = false
  }
  
  public func showReasonBottomSheet() {
    isPresentReasonBottomSheet = true
  }
  
  public func hideReasonBottomSheet() {
    isPresentReasonBottomSheet = false
  }
  
  //MARK: - Navigator
  
  public func navigateToPaymentGateway() {
    paymentNavigator.navigateToPaymentGateway(paymentURL)
  }
  
  public func backToHome() {
    dashboardResponder.gotoDashboard()
  }
  
}
