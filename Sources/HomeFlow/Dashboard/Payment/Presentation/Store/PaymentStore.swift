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
  private let ongoingRepository: OngoingRepositoryLogic
  private let probonoRepository: GetKTPDataRepositoryLogic
  private let cancelationRepository: PaymentCancelationRepositoryLogic
  private let ongoingNavigator: OngoingNavigator
  private let paymentNavigator: PaymentNavigator
  private let dashboardResponder: DashboardResponder
  
  @Published public var isLoading: Bool = false
  @Published public var isPresentVoucherBottomSheet: Bool = false
  @Published public var timeConsultation: String = ""
  @Published public var orderViewModel: OrderViewModel = .init()
  @Published public var activateButton: Bool = false
  @Published public var voucherCode: String = ""
  @Published public var showXMark: Bool = false
  @Published public var voucherErrorText: String = ""
  @Published public var voucherViewModel: VoucherViewModel = .init()
  @Published public var voucherFilled: Bool = false
  @Published public var isPresentTncBottomSheet: Bool = false
  @Published public var isPresentMakeSureBottomSheet: Bool = false
  @Published public var showDetailIssues: Bool = false
  @Published public var isPresentReasonBottomSheet: Bool = false
  @Published public var isPresentDetailConsultationBottomSheet: Bool = false
  @Published public var isPresentWarningPaymentBottomSheet: Bool = false
  @Published public var isPresentVoucherTnCBottomSheet: Bool = false
  @Published public var reasons: [ReasonEntity] = []
  @Published public var showTimeRemainig: Bool = false
  @Published var isVirtualAccountChecked: Bool = false
  @Published var isEWalletChecked: Bool = false
  @Published var isPayButtonActive: Bool = false
  @Published var voucherCount: Int = 0
  @Published public var elligibleVoucherEntities: [EligibleVoucherEntity] = []
  
  public var paymentTimeRemaining: CurrentValueSubject<TimeInterval, Never> = .init(0)
  public var message = CurrentValueSubject<String, Never>("")
  private var treatmentEntities: [TreatmentEntity] = []
  private var userSessionData: UserSessionData?
  private var paymentEntity: PaymentEntity = .init()
  public var expiredDateTime: String = ""
  private var userCase: UserCases = .init()
  public var selectedReason: ReasonEntity? = nil
  public var reason: String? = nil
  public var payments: [PaymentMethodViewModel] = []
  public var selectedPaymentCategory: PaymentCategory = .VA
  public var firstDuration: String = ""
  public var idCardEntity: IDCardEntity = .init()
  public var voucherTnC: String = ""
  public var eligibleVoucherEntity: EligibleVoucherEntity = .init()
  public var showSnackBar = PassthroughSubject<Bool, Never>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init() {
    self.userSessionDataSource = MockUserSessionDataSource()
    self.lawyerInfoViewModel = .init()
    self.orderProcessRepository = MockOrderProcessRepository()
    self.paymentRepository = MockPaymentRepository()
    self.treatmentRepository = MockTreatmentRepository()
    self.ongoingRepository = MockHomeRepository()
    self.ongoingNavigator = MockNavigator()
    self.paymentNavigator = MockNavigator()
    self.dashboardResponder = MockNavigator()
    self.cancelationRepository = MockPaymentRepository()
    self.probonoRepository = MockGetKTPRepository()
  }
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    lawyerInfoViewModel: LawyerInfoViewModel,
    orderProcessRepository: OrderProcessRepositoryLogic,
    paymentRepository: PaymentRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic,
    ongoingRepository: OngoingRepositoryLogic,
    cancelationRepository: PaymentCancelationRepositoryLogic,
    probonoRepository: GetKTPDataRepositoryLogic,
    ongoingNavigator: OngoingNavigator,
    paymentNavigator: PaymentNavigator,
    dashboardResponder: DashboardResponder
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.lawyerInfoViewModel = lawyerInfoViewModel
    self.orderProcessRepository = orderProcessRepository
    self.paymentRepository = paymentRepository
    self.treatmentRepository = treatmentRepository
    self.ongoingRepository = ongoingRepository
    self.probonoRepository = probonoRepository
    self.ongoingNavigator = ongoingNavigator
    self.paymentNavigator = paymentNavigator
    self.dashboardResponder = dashboardResponder
    self.cancelationRepository = cancelationRepository
    
    observer()
    setupFirstDuration()
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func fetchProbonoStatus() async {
    probonoRepository
      .checkKTPStatus(headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken))
      .sink { result in
        switch result {
        case .failure(let error):
          self.indicateError(error: error)
        case .finished:
          break
        }
      } receiveValue: { [weak self] entity in
        guard let self = self else { return }
        idCardEntity = entity
      }.store(in: &subscriptions)
  }
  
  @MainActor
  public func requestElligibleVoucher() async {
    elligibleVoucherEntities.removeAll()
    
    do {
      let entities = try await paymentRepository.requestEligibleVoucher(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: EligibleVoucherParamRequests(
          orderNumber: lawyerInfoViewModel.orderNumber
        )
      )
      
      elligibleVoucherEntities = entities
      voucherCount = entities.count
    } catch {
      guard let error = error as? ErrorMessage else {
        return
      }
      
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func requestPaymentMethods() async {
    payments.removeAll()
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let entities = try await paymentRepository.requestPaymentMethod(headers: HeaderRequest(token: token))
      payments = entities.map(PaymentMethodEntity.mapTo(_:))
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage else {
        return
      }
      
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func requestCancelation() async {
    var success: Bool = false
    
    if paymentTimeRemaining.value <= 0 {
      success = await sendCancelationReason()
    } else {
      success = await requestCancelationPayment()
    }
    
    if success {
      isPresentReasonBottomSheet = false
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      backToHome()
    }
  }
  
  @MainActor
  public func sendCancelationReason() async -> Bool {
    indicateLoading()
    var success: Bool = false
    var parameters: CancelPaymentRequest = .init(dismiss: false)
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return false
      }
      
      if let title = selectedReason?.title, title.contains("Lainnya") {
        parameters = CancelPaymentRequest(
          orderNumber: getOrderNumber(),
          reasonID: selectedReason?.id ?? 0,
          reason: reason
        )
      } else {
        parameters = CancelPaymentRequest(
          orderNumber: getOrderNumber(),
          reasonID: selectedReason?.id ?? 0,
          reason: selectedReason?.title
        )
      }
      
      success = try await cancelationRepository.requestCancelReason(
        headers: HeaderRequest(token: token),
        parameters: parameters
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
  public func requestCancelationPayment() async -> Bool {
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
          reason: ((selectedReason?.title.contains("Lainnya")) != nil) ? reason : selectedReason?.title
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
  public func fetchCancelationReasons() async {
    reasons.removeAll()
    
    guard let token = userSessionData?.remoteSession.remoteToken
    else { return }
    
    do {
      reasons = try await cancelationRepository.requestReasons(
        headers: HeaderRequest(token: token)
      )
      
      GLogger(
        .info,
        layer: "Presentation",
        message: "reasons \(reasons)"
      )
      
      indicateSuccess()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func applyVoucher(_ code: String) async {
    voucherViewModel = await requestVoucher(code)
    
    if voucherViewModel.success {
      voucherFilled = true
      setDuration(voucherViewModel.duration)
      await requestOrderByNumber()
    }
    
  }
  
  @MainActor
  public func removeVoucher() async {
    let success = await requestRemoveVoucher()
    if success {
      voucherViewModel.setCode("")
      eligibleVoucherEntity = .init()
      voucherFilled = false
      getTimeConsultation(from: treatmentEntities)
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
      indicateSuccess()
      calculateTimeRemainig()
      handleAutoApplyVoucher(entity)
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func fetchTreatment() async {
    treatmentEntities.removeAll()
    do {
      treatmentEntities = try await treatmentRepository.fetchTreatments()
      getTimeConsultation(from: treatmentEntities)
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  private func requestVoucher(_ code: String) async -> VoucherViewModel {
    var viewModel: VoucherViewModel = .init()
    
    do {
      let entity = try await paymentRepository.requestUseVoucher(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: VoucherParamRequest(
          orderNumber: lawyerInfoViewModel.orderNumber,
          voucherCode: code
        )
      )
      
      indicateSuccess()
      
      viewModel = VoucherEntity.mapTo(entity)
      lawyerInfoViewModel.duration = "\(viewModel.duration) Menit"
      showSnackBar.send(true)
      message.send("Berhasil mendapatkan Promo")
      activateButton = false
      
    } catch {
      guard let error = error as? ErrorMessage else { return .init() }
      voucherError(error)
      activateButton = false
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
          voucherCode: voucherViewModel.code
        )
      )
      
      indicateSuccess()
      
      lawyerInfoViewModel.duration = firstDuration
      
      //modify array of vouchers
      let index = elligibleVoucherEntities.firstIndex {
        return $0.code == voucherViewModel.code
      } ?? 0
      
      elligibleVoucherEntities[index].isUsed = false
      
      
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
    indicateLoading()
    
    do {
      paymentEntity = try await paymentRepository.requestCreatePayment(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: PaymentParamRequest(
          orderNumber: lawyerInfoViewModel.orderNumber,
          consultationGuideAnswerId: 2,
          voucherCode: voucherViewModel.code,
          paymentChannelCategory: selectedPaymentCategory.rawValue
        )
      )
      UserDefaults.standard.set(selectedPaymentCategory.rawValue, forKey: "latestSelectedPayment")
      UserDefaults.standard.synchronize()
      indicateSuccess()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  public func requestOngoingUserCases() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      
      let entities = try await ongoingRepository.fetchOngoingUserCases(
        headers: HeaderRequest(token: token).toHeaders(),
        parameters: UserCasesParamRequest(type: "ongoing")
      )
      if entities.count > 0 {
        userCase = entities[0]
      }
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func requestRejectionPayment(id: Int) async -> Bool {
    var success: Bool = false
    
    indicateLoading()
    
    guard let token = userSessionData?.remoteSession.remoteToken else {
      return false
    }
    
    do {
      success = try await paymentRepository.requestRejectionPayment(
        headers: HeaderRequest(token: token),
        parameters: PaymentRejectionRequest(id: id)
      )
      
      indicateSuccess()
    } catch {
      guard let error = error as? ErrorMessage else { return false }
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
  
  //MARK: - Other function
  
  private func handleAutoApplyVoucher(_ entity: OrderEntity) {
    if let voucher = entity.voucherAuto, voucher.success  {
      voucherFilled = true
      voucherViewModel.duration = voucher.duration
      voucherViewModel.setCode(voucher.code)
      voucherViewModel.setAmount(voucher.amount)
      setDuration(voucher.duration)
      eligibleVoucherEntity = EligibleVoucherEntity(
        name: "",
        code: voucher.code,
        tnc: voucher.tnc,
        expiredDate: Date(),
        isUsed: false
      )
      updateVoucherArrays()
    } else{
      voucherFilled = false
      voucherCode = ""
      voucherViewModel.setCode("")
      setDuration(0)
    }
  }
  
  public func getVoucherTnC() -> String {
    return """
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Numbered List</title>
          <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@100&display=swap" rel="stylesheet">
          <style>
              body {
                  font-family: 'Lexend-Light', sans-serif;
                  font-weight: 300;
                  font-size: 14px;
                  marging: 0;
                  padding: 0;
              }
              ol {
                display: block;
                list-style-type: decimal;
                margin-top: 1em;
                margin-bottom: 1em;
                margin-left: 0;
                margin-right: 0;
                padding-left: 20px;
              }
          </style>
      </head>
        <body>\(eligibleVoucherEntity.tnc)</body>
      </html>
  """
  }
  
  public func showVoucherTnCBottomSheet() {
    isPresentVoucherTnCBottomSheet = true
  }
  
  public func setupFirstDuration() {
    firstDuration = lawyerInfoViewModel.duration ?? ""
  }
  
  public var activatePayButton: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($isEWalletChecked, $isVirtualAccountChecked).map { (ewallet, va) in
      return ewallet || va
    }.eraseToAnyPublisher()
  }
  
  public func getVAs() -> [PaymentMethodViewModel] {
    return payments.filter { $0.category == .VA }
  }
  
  public func getEWallets() -> [PaymentMethodViewModel] {
    return payments.filter { $0.category == .EWALLET }
  }
  
  @MainActor
  public func checkVirtualAccount() {
    if !isVirtualAccountChecked {
      isVirtualAccountChecked = true
      isEWalletChecked = false
      return
    }
  }
  
  @MainActor
  public func checkEWallet() {
    if !isEWalletChecked {
      isEWalletChecked = true
      isVirtualAccountChecked = false
      return
    }
  }
  
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
  
  private func setDuration(_ duration: Int) {
    self.timeConsultation = "\(duration) Menit"
  }
  
  public func getVoucherText() -> String {
    return "Hemat \(voucherViewModel.amount)"
  }
  
  public func getVoucherDuration() -> String {
    return "Durasi konsultasi akan selama \(voucherViewModel.duration) menit"
  }
  
  public func isProbono() -> Bool {
    return lawyerInfoViewModel.isProbono
  }
  
  public func fetchUserSession() async {
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
  
  public func getCategoryBottomSheet() -> String {
    return lawyerInfoViewModel.category ?? ""
  }
  
  public func getTypeBottomSheet() -> String {
    return lawyerInfoViewModel.type ?? ""
  }
  
  public func getDurationBottomSheet() -> String {
    return lawyerInfoViewModel.duration ?? ""
  }
  
  public func getDetailIssueName() -> String {
    return lawyerInfoViewModel.detailIssues
  }
  
  public func getLawyersName() -> String {
    return lawyerInfoViewModel.name
  }
  
  public func getAgency() -> String {
    return lawyerInfoViewModel.agency
  }
  
  public func getExpiredDate() -> String {
    return "Bayar sebelum \(orderViewModel.expiredHours())"
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
    
    if let discount = orderViewModel.discount {
      items.append(discount)
    }
    
    items.append(orderViewModel.lawyerFee)
    items.append(orderViewModel.adminFee)
    
    return items.sorted(by: {$0.id < $1.id})
  }
  
  public func getTotalAmount() -> String {
    return orderViewModel.totalAmount
  }
  
  public func getPriceBottom() -> String {
    if isProbono() {
      return "Gratis"
    }
    
    return orderViewModel.totalAmount
  }
  
  public func getTotalAdjustment() -> String {
    return "Anda hemat \(orderViewModel.getTotalAdjustment()) di transaksi ini!"
  }
  
  public func getTNCVoucher() -> String {
    return voucherViewModel.tnc
  }
  
  public func getDetailIssue() -> String {
    return lawyerInfoViewModel.detailIssues
  }
  
  public func calculateTimeRemainig() {
    paymentTimeRemaining.value = orderViewModel.getRemainingMinutes()
    showTimeRemainig = true
  }
  
  public var voucherCountInfo: String {
    return "\(voucherCount) Voucher tersedia"
  }
  
  public func updateVoucherArrays() {
    if let index = elligibleVoucherEntities.firstIndex(where: { $0.code == eligibleVoucherEntity.code}) {
      elligibleVoucherEntities[index].isUsed = true
    }
  }
  
  //MARK: - Navigator
  
  @MainActor
  public func navigateToNextDestination() {
    Task {
      await requestCreatePayment()
      await requestOngoingUserCases()
      
      if !paymentEntity.urlString.isEmpty,
         let paymentURL = paymentEntity.getPaymentURL() {
        
        ongoingNavigator.navigateToPaymentURL(paymentURL)
        navigateToPaymentCheck()
        
        return
      }
      
      ongoingNavigator.navigateToWaitingRoom(
        userCase,
        roomkey: paymentEntity.roomKey,
        consultId: userCase.booking?.consultation_id ?? 0,
        status: false,
        paymentCategory: selectedPaymentCategory,
        isProbono: isProbono()
      )
      
    }
  }
  
  private func navigateToPaymentCheck() {
    paymentNavigator.navigateToPaymentCheck(
      lawyerInfo: lawyerInfoViewModel,
      price: getTotalAmount(),
      roomkey: paymentEntity.roomKey,
      consultId: userCase.booking?.consultation_id ?? 0,
      urlPayment: paymentEntity.urlString,
      orderID: lawyerInfoViewModel.orderNumber,
      paymentCategory: selectedPaymentCategory
    )
  }
  
  public func backToHome() {
    dashboardResponder.gotoDashboard()
  }
  
  //MARK: - Indicate
  
  public func showVoucherTncBottomSheet() {
    isPresentVoucherTnCBottomSheet = true
  }
  
  public func hideVoucherTncBottomSheet() {
    isPresentVoucherTnCBottomSheet = false
  }
  
  public func showWarningBottomSheet() {
    isPresentMakeSureBottomSheet = true
  }
  
  public func dismissWaningBottomSheet() {
    isPresentMakeSureBottomSheet = false
  }
  
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
  
  public func showReasonBottomSheet() {
    isPresentReasonBottomSheet = true
  }
  
  public func hideReasonBottomSheet() {
    isPresentReasonBottomSheet = false
    Task {
      if paymentTimeRemaining.value <= 0 {
        _ = await sendCancelationReason()
      }
    }
  }
  
  public func showDetailConsultationBottomSheet() {
    isPresentDetailConsultationBottomSheet = true
  }
  
  public func hideDetailConsultationBottomSheet() {
    isPresentDetailConsultationBottomSheet = false
  }
  
  public func showWarningPaymentBottomSheet() {
    isPresentWarningPaymentBottomSheet = true
  }
  
  public func hideWarningPaymentBottomSheet() {
    isPresentWarningPaymentBottomSheet = false
  }
  
  //MARK: - Observer
  
  private func observer() {
    
    activatePayButton
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        if self.isProbono() {
          self.isPayButtonActive = true
          return
        }
        
        self.isPayButtonActive = state
      }.store(in: &subscriptions)
    
    $isVirtualAccountChecked
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        
      }.store(in: &subscriptions)
    
    $isEWalletChecked
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        
      }.store(in: &subscriptions)
    
    paymentTimeRemaining
      .dropFirst()
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { value in
        if value <= 0 {
//          self.showReasonBottomSheet()
        }
      }
      .store(in: &subscriptions)
    
    $voucherCode
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { text in
        self.activateButton = !text.isEmpty
        self.showXMark = !text.isEmpty
      }.store(in: &subscriptions)
  }
  
}
