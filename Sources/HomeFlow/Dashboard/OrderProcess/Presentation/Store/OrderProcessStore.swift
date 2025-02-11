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
import UIKit

public class OrderProcessStore: ObservableObject {
  
  //Dependency
  public let advocate: Advocate
  public var selectedPriceCategories: PriceCategoryViewModel
  private let sktmModel: ClientGetSKTM?
  private let repository: OrderProcessRepositoryLogic
  private let treatmentRepository: TreatmentRepositoryLogic
  private let orderServiceRepository: OrderServiceRepositoryLogic
  private let probonoRepository: GetKTPDataRepositoryLogic
  private let paymentNavigator: PaymentNavigator
  private let sktmNavigator: SKTMNavigator
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let probonoNavigator: ProbonoNavigator
  
  @Published public var orderServiceFilled: Bool = false
  @Published public var detailCostFilled: Bool = false
  @Published public var issueText: String = ""
  @Published public var errorText: String = "Minimal 10 karakter"
  @Published public var lawyerInfoViewModel: LawyerInfoViewModel = .init()
  @Published public var isPresentBottomSheet: Bool = false
  @Published public var isPresentChangeCategoryIssue: Bool = false
  @Published public var timeConsultation: String = ""
  @Published public var isTextValid: Bool = true
  @Published public var isScrollToTop: Bool = true
  @Published public var isProbonoActive: Bool = false
  @Published public var buttonActive: Bool = false
  @Published public var error: ErrorMessage = .init()
  @Published public var priceCategories: [PriceCategoryViewModel] = []
  @Published public var orderServiceViewModel: [OrderServiceViewModel] = []
  
  public var priceCategoriesCopy: [PriceCategoryViewModel] = []
  private var treatmentEntities: [TreatmentEntity] = []
  private var orderServiceEntities: [OrderServiceEntity] = []
  private var userSessionData: UserSessionData?
  public var isLoading: Bool = false
  public var message: String = ""
  public var typeSelected: String = ""
  private var detailPriceAdvocate: DetailPriceAdvocate?
  public var idCardEntity: IDCardEntity = .init()
  private var subscriptions = Set<AnyCancellable>()
  
  public init() {
    self.advocate = .init()
    self.selectedPriceCategories = .init()
    self.sktmModel = .init()
    self.userSessionDataSource = MockUserSessionDataSource()
    self.treatmentRepository = MockTreatmentRepository()
    self.orderServiceRepository = MockOrderServiceRepository()
    self.repository = MockOrderProcessRepository()
    self.paymentNavigator = MockNavigator()
    self.sktmNavigator = MockNavigator()
    self.probonoNavigator = MockNavigator()
    self.probonoRepository = MockGetKTPRepository()
  }
  
  public init(
    advocate: Advocate,
    selectedPriceCategories: PriceCategoryViewModel,
    sktmModel: ClientGetSKTM?,
    userSessionDataSource: UserSessionDataSourceLogic,
    repository: OrderProcessRepositoryLogic,
    treatmentRepository: TreatmentRepositoryLogic,
    orderServiceRepository: OrderServiceRepositoryLogic,
    probonoRepository: GetKTPDataRepositoryLogic,
    paymentNavigator: PaymentNavigator,
    sktmNavigator: SKTMNavigator,
    probonoNavigator: ProbonoNavigator
  ) {
    self.advocate = advocate
    self.selectedPriceCategories = selectedPriceCategories
    self.sktmModel = sktmModel
    self.userSessionDataSource = userSessionDataSource
    self.treatmentRepository = treatmentRepository
    self.orderServiceRepository = orderServiceRepository
    self.repository = repository
    self.probonoRepository = probonoRepository
    self.paymentNavigator = paymentNavigator
    self.sktmNavigator = sktmNavigator
    self.probonoNavigator = probonoNavigator
    
    setSelectedDetailPriceAdvocate()
    setLawyerInfo()
    priceCategories = getPriceCategories()
    priceCategoriesCopy = priceCategories
    
    observer()
    
  }
  
  //MARK: - API
  
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
        Task {
          await self.fetchOrderService()
        }
      }.store(in: &subscriptions)
  }
  
  @MainActor
  private func requestBookingOrder() async -> BookingOrderEntity? {
    indicateLoading()
    
    var entity: BookingOrderEntity?
    
    let bookingOrderParamRequest = BookingOrderParamRequest(
      type: "INSTANT_CONSULTATION",
      lawyerId: lawyerInfoViewModel.id,
      skillId: selectedPriceCategories.skillId,
      description: issueText,
      orderType: getOrderType()
    )
    
    do {
      entity = try await repository.requestBookingOrder(
        HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        bookingOrderParamRequest
      )
      
      indicateSuccess()
      
      return entity
      
    } catch {
      guard let error = error as? ErrorMessage else {
        return nil
      }
      
      indicateError(error: error)
    }
    
    return entity
    
  }
  
  @MainActor
  public func fetchTreatment() async {
    do {
      treatmentEntities = try await treatmentRepository.fetchTreatments()
      getTimeConsultation(from: treatmentEntities)
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func fetchOrderService() async {
    orderServiceEntities.removeAll()
    orderServiceViewModel.removeAll()
    
    let orderServiceParamRequest = OrderServiceParamRequest(
      lawyerSkillPriceId: "\(detailPriceAdvocate?.lawyer_skill_price_id ?? 0)")
    
    do {
      orderServiceEntities = try await orderServiceRepository.fetchOrderService(
        HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        orderServiceParamRequest
      )
      
      setOrderServiceArrayModel()
      
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  //MARK: - Other function
  
  public func isOrderProbono() -> Bool {
    return typeSelected == "PROBONO"
  }
  
  public func getUnSelectedArray() -> [PriceCategoryViewModel] {
    var array: [PriceCategoryViewModel] = []
    for (_, item) in priceCategories.enumerated() {
      array.append(PriceCategoryViewModel(
        id: item.id,
        lawyerSkillPriceId: item.lawyerSkillPriceId,
        skillId: item.skillId,
        name: item.name,
        caseExample: item.caseExample,
        price: item.price,
        originalPrice: item.originalPrice,
        isSelected: false))
    }
    return array
  }
  
  public func getSelectedID() -> Int {
    return selectedPriceCategories.id
  }
  
  public func getHeightChangeBottomSheet() -> CGFloat {
    var height: CGFloat = 0
    if priceCategories.count == 1 {
      height = 400
    } else if priceCategories.count == 2 {
      height = 500
    } else if priceCategories.count == 3 {
      height = 600
    } else if priceCategories.count > 3 {
      height = (UIScreen.main.bounds.height - 200)
    }
    return height
  }
  
  public func getDurationPagePayment() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return item.duration
      }
    }
    return ""
  }
  
  public func getTypePagePayment() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return item.name
      }
    }
    return ""
  }
  
  public func getCategoryPagePayment() -> String {
    return detailPriceAdvocate?.name ?? ""
  }
  
  public func getIssueName() -> String {
    return selectedPriceCategories.name
  }
  
  public func getOrderType() -> String {
    return typeSelected
  }
  
  public func getDetailInfoBottom() -> String {
    if detailCostFilled {
      return "Transaksi ini mungkin dikenakan biaya layanan."
    } else {
      return "Rincian akan ditampilkan setelah memilih konsultasi diatas"
    }
  }
  
  public func getOriginalPrice() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return item.originalPrice
      }
    }
    return ""
  }
  
  public func getDiscountPrice() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return "- \(item.discountPrice)"
      }
    }
    return ""
  }
  
  public func getPriceBottom() -> String {
    if typeSelected == "PROBONO" {
      return "Gratis"
    }
    
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return item.price
      }
    }
    
    return "-"
  }
  
  public func getTotalPrice() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return item.price
      }
    }
    return ""
  }
  
  public func getName() -> String {
    for item in orderServiceViewModel {
      if item.type == typeSelected {
        return "Biaya Paket \(item.name)"
      }
    }
    return ""
  }
  
  public func getDiscountName() -> String {
    return "Diskon Perqara"
  }
  
  public func getOrderServiceArrayModel() -> [OrderServiceViewModel] {
    return orderServiceViewModel
  }
  
  public func setOrderServiceArrayModel() {
    for (index, item) in orderServiceEntities.enumerated() {
      
      if idCardEntity.status == .USED {
        if item.type != "PROBONO" {
          let price = CurrencyFormatter.toCurrency(NSNumber(value: item.price))
          let originalPrice = CurrencyFormatter.toCurrency(NSNumber(value: item.originalPrice))
          let priceSelect = Float(item.price)
          let durationSelect = Float(item.duration)
          let worthPriceMinuteFloat = Float(priceSelect/durationSelect).rounded(.up)
          let worthPriceMinuteResult = Int(worthPriceMinuteFloat)
          let descPrice = "senilai \(worthPriceMinuteResult)/menit"
          var isDiscount = true
          if item.price == item.originalPrice {
            isDiscount = false
          }
    //      var isSKTM = false
    //      if item.type == "PROBONO" {
    //        isSKTM = true
    //        if getSKTMQuota() > 0 {
    //          price = "GRATIS"
    //          descPrice = "kuota tersedia: \(getSKTMQuota())"
    //        } else {
    //          price = "GRATIS"
    //          descPrice = "S&K Berlaku"
    //        }
    //      }
          var isSaving = false
          if item.type == "REGULAR_AUDIO_VIDEO" {
            isSaving = true
          }
          let discountInt = (item.originalPrice - item.price)
          let discount = "\(CurrencyFormatter.toCurrency(NSNumber(value: discountInt)))"
          
          var isDisable = false
          
          if item.status == "INACTIVE" {
            isDisable = true
          }
          
          orderServiceViewModel.append(
            OrderServiceViewModel.init(
              id: index,
              name: item.name,
              type: item.type,
              status: item.status,
              duration: "\(item.duration) Menit",
              price: price,
              originalPrice: originalPrice,
              iconURL: item.iconURL,
              isDiscount: isDiscount,
              isSKTM: false,
              isHaveQuotaSKTM: false,
              quotaSKTM: 0,
              isKTPActive: idCardEntity.status == .ACTIVE,
              isSaving: isSaving,
              isDisable: isDisable,
              isSelected: false,
              descPrice: descPrice,
              discountPrice: discount
            )
          )
        }
      } else {
        let price = CurrencyFormatter.toCurrency(NSNumber(value: item.price))
        let originalPrice = CurrencyFormatter.toCurrency(NSNumber(value: item.originalPrice))
        let priceSelect = Float(item.price)
        let durationSelect = Float(item.duration)
        let worthPriceMinuteFloat = Float(priceSelect/durationSelect).rounded(.up)
        let worthPriceMinuteResult = Int(worthPriceMinuteFloat)
        let descPrice = "senilai \(worthPriceMinuteResult)/menit"
        var isDiscount = true
        if item.price == item.originalPrice {
          isDiscount = false
        }
  //      var isSKTM = false
  //      if item.type == "PROBONO" {
  //        isSKTM = true
  //        if getSKTMQuota() > 0 {
  //          price = "GRATIS"
  //          descPrice = "kuota tersedia: \(getSKTMQuota())"
  //        } else {
  //          price = "GRATIS"
  //          descPrice = "S&K Berlaku"
  //        }
  //      }
        var isSaving = false
        if item.type == "REGULAR_AUDIO_VIDEO" {
          isSaving = true
        }
        let discountInt = (item.originalPrice - item.price)
        let discount = "\(CurrencyFormatter.toCurrency(NSNumber(value: discountInt)))"
        
        var isDisable = false
        
        if item.status == "INACTIVE" {
          isDisable = true
        }
        
        orderServiceViewModel.append(
          OrderServiceViewModel.init(
            id: index,
            name: item.name,
            type: item.type,
            status: item.status,
            duration: "\(item.duration) Menit",
            price: price,
            originalPrice: originalPrice,
            iconURL: item.iconURL,
            isDiscount: isDiscount,
            isSKTM: false,
            isHaveQuotaSKTM: false,
            quotaSKTM: 0,
            isKTPActive: idCardEntity.status == .ACTIVE,
            isSaving: isSaving,
            isDisable: isDisable,
            isSelected: false,
            descPrice: descPrice,
            discountPrice: discount
          )
        )
      }
      
    }
    
  }
  
  public func onTapChange(id: Int) {
    priceCategories = []
    for (indexArray,item) in priceCategoriesCopy.enumerated() {
      if id == item.id {
        priceCategoriesCopy[indexArray].isSelected = true
        selectedPriceCategories = item
      } else {
        priceCategoriesCopy[indexArray].isSelected = false
      }
    }
    priceCategories = priceCategoriesCopy
    setSelectedDetailPriceAdvocate()
    dismissChangeCategory()
  }
  
  public func selectedUpdate(type: String) {
    for (indexArray,item) in orderServiceViewModel.enumerated() {
      if type == item.type {
        if type == "PROBONO" && !item.isKTPActive {
          return
        }
        
        typeSelected = type
        orderServiceViewModel[indexArray].isSelected = true
        self.buttonActive = true
      } else {
        orderServiceViewModel[indexArray].isSelected = false
      }
    }
    orderServiceFilled = true
    detailCostFilled = true
    
  }
  
  public func getSKTMQuota() -> Int {
    if let quota = sktmModel?.data?.quota, quota > 0  {
      return quota
    }
    return 0
  }
  
  public func getUserSKTMData() -> Bool {
    if let quota = sktmModel?.data?.quota, quota > 0  {
      return true
    }
    return false
  }
    
  public func setSelectedDetailPriceAdvocate() {
    for item in advocate.detail {
      if item?.skill_id == selectedPriceCategories.skillId {
        detailPriceAdvocate = item
      }
    }
    
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
      price: selectedPriceCategories.price,
      originalPrice: advocate.getOriginalPrice(),
      isDiscount: advocate.isDiscount,
      isProbono: sktmQuota > 0,
      orderNumber: "",
      detailIssues: issueText
    )
  }
  
  public func setErrorText() {
    if issueText.count == 0 {
      errorText = "Deskripsi masalah wajib diisi"
    }
    isTextValid = false
  }
  
  public func processNavigation() {
    if isProbonoActive {
      Task {
        await navigateToPayment()
      }
      return
    }
    
    showOrderInfoBottomSheet()
  }
  
  public func isProbono() -> Bool {
    return idCardEntity.status == .ACTIVE
  }
  
  private func getTimeConsultation(from entities: [TreatmentEntity]) {
    let type = isProbonoActive ? "PROBONO" : "REGULAR"
    let entity = entities.filter{ $0.type == type }.first!
    timeConsultation = "\(entity.duration) Menit"
  }
  
  //MARK: - Fetch Local
  
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
  
  public func showChangeCategory() {
    isPresentChangeCategoryIssue = true
  }
  
  public func dismissChangeCategory() {
    isPresentChangeCategoryIssue = false
  }
  
  public func getPrice() -> String {
    return lawyerInfoViewModel.price
  }
  
  public func getPriceProbonoOnly() -> String {
    if isProbonoActive {
      return "Gratis"
    }
    return lawyerInfoViewModel.price
  }
  
  public func getPriceCategories() -> [PriceCategoryViewModel] {
    var categories: [PriceCategoryViewModel] = []
    for (indexArray,item) in advocate.detail.enumerated() {
      var selected = false
      if item?.name == selectedPriceCategories.name {
        selected = true
      }
      categories.append(PriceCategoryViewModel(
        id: indexArray,
        lawyerSkillPriceId: item?.lawyer_skill_price_id ?? 0,
        skillId: item?.skill_id ?? 0,
        name: item?.name ?? "",
        caseExample: item?.case_example ?? "",
        price: item?.price ?? "",
        originalPrice: item?.original_price ?? "",
        isSelected: selected))
    }
    return categories
  }
  
  public func setPriceCategory(_ price: String) {
    lawyerInfoViewModel.setPrice(price)
  }
  
  public func isValidText(_ text: String) -> AnyPublisher<Bool, Never> {
    return Future<Bool, Never> { promise in
      promise(.success(text.count > 9))
    }.eraseToAnyPublisher()
  }
  
  
  //MARK: - Navigator
  
  @MainActor
  public func navigateToPayment() {
    hideOrderInfoBottomSheet()
    
    Task {
      let entity = await requestBookingOrder()
      guard let orderNumber = entity?.orderNumber else {
        indicateError(
          error: ErrorMessage(
            title: "Gagal",
            message: "Gagal membuat konsultasi."
          )
        )
        return
      }
      
      let lawyerInfo = LawyerInfoViewModel(
        id: lawyerInfoViewModel.id,
        imageURL: lawyerInfoViewModel.imageURL,
        name: lawyerInfoViewModel.name,
        agency: lawyerInfoViewModel.agency,
        price: lawyerInfoViewModel.price,
        originalPrice: lawyerInfoViewModel.originalPrice,
        isDiscount: lawyerInfoViewModel.isDiscount,
        isProbono: isOrderProbono(),
        orderNumber: orderNumber,
        detailIssues: issueText,
        category: getCategoryPagePayment(),
        type: getTypePagePayment(),
        duration: getDurationPagePayment()
      )
      
      paymentNavigator.navigateToPayment(lawyerInfo)
    }
    
  }
  
  public func navigateToRequestProbono() {
    
    probonoNavigator.navigateToProbonoService(page: Constant.Page.ORDER_PROCESS)
    
//    guard let _ = userSessionData else {
//      sktmNavigator.navigateToUploadSKTM()
//      return
//    }
//    
//    guard let status = sktmModel?.data?.status else {
//      sktmNavigator.navigateToUploadSKTM()
//      return
//    }
//    
//    if status == "ON_PROCESS" || status == "ACTIVE"
//        || status == "EMPTY_QUOTA" || status == "EXPIRED"
//        || status == "FAILED" {
//      
//      sktmNavigator.navigateToDetailSKTM(sktmModel)
//    } else {
//      sktmNavigator.navigateToUploadSKTM()
//    }
    
  }
  
  public func navigateToDecisionTree() {
    sktmNavigator.navigateDecisionTree(sktmModel)
  }
  
  public func navigateToUploadSKTM() {
    sktmNavigator.navigateToUploadSKTM()
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
  
  @MainActor
  private func indicateError(error: ErrorMessage) {
    isLoading = false
    self.error = error
  }
  
  private func indicateSuccess() {
    isLoading = false
  }
  
  //MARK: - Observer
  
  private func observer() {
    $error
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { message in
        
      }.store(in: &subscriptions)
    
//    $orderServiceFilled
//      .dropFirst()
//      .receive(on: RunLoop.main)
//      .subscribe(on: RunLoop.main)
//      .sink { message in
//        print("$orderServiceFilled")
//      }.store(in: &subscriptions)
//    
//    $detailCostFilled
//      .dropFirst()
//      .receive(on: RunLoop.main)
//      .subscribe(on: RunLoop.main)
//      .sink { message in
//        print("$detailCostFilled")
//      }.store(in: &subscriptions)
    
    $issueText
      .dropFirst()
      .flatMap { self.isValidText($0) }
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        self.isTextValid = state
        self.isScrollToTop = !state
        if self.issueText.count < 10 {
          self.errorText = "Minimal 10 karakter"
        } else {
          self.errorText = ""
        }
      }.store(in: &subscriptions)
    
    $isProbonoActive
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        lawyerInfoViewModel.setIsProbonoActive(state)
        getTimeConsultation(from: treatmentEntities)
      }.store(in: &subscriptions)
    
  }
  
}

public protocol OrderProcessStoreFactory {
  func makeOrderProcessStore() -> OrderProcessStore
}
