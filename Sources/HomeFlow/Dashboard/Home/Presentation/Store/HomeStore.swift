//
//  HomeViewModel.swift
//
//
//  Created by Ilham Prabawa on 30/09/23.
//

import Foundation
import AprodhitKit
import GnDKit
import Network
import Combine
import Environment
import AppsFlyerLib

@MainActor
public class HomeStore: ObservableObject {
  
  //MARK: - Properties
  //Dependencies
  private let homeRepository: HomeRepositoryLogic
  private let ongoingRepository: OngoingRepositoryLogic
  private let sktmRepository: SKTMRepositoryLogic
  private let idCardRepository: GetKTPDataRepositoryLogic
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let cancelationRepository: PaymentCancelationRepositoryLogic
  private let meRepository: MeRepositoryLogic
  private let onlineAdvocateNavigator: OnlineAdvocateNavigator
  private let topAdvocateNavigator: TopAdvocateNavigator
  private let articleNavigator: ArticleNavigator
  private let searchNavigator: SearchNavigator
  private let categoryNavigator: CategoryNavigator
  private let advocateListNavigator: AdvocateListNavigator
  private let sktmNavigator: SKTMNavigator
  private let mainTabBarResponder: MainTabBarResponder
  private let ongoingNavigator: OngoingNavigator
  private let loginResponder: LoginResponder
  private let refundNavigator: RefundNavigator
  private let probonoNavigator: ProbonoNavigator
  
  public let monitor = NWPathMonitor()
  let dispatchQueue = DispatchQueue(label: "Monitor")
  
  //State
  @Published public var onlinedAdvocates: [Advocate] = []
  @Published public var skills: [AdvocateSkills] = []
  @Published public var topAdvocates: [TopAdvocateViewModel] = []
  @Published public var topAgencies: [TopAgencyViewModel] = []
  @Published public var categories: [CategoryArticleViewModel] = []
  @Published public var articles: [ArticleViewModel] = []
  @Published public var showBottomView: Bool = false
  @Published public var isLoading: Bool = false
  @Published public var fetchSucceeded: Bool = false
  @Published public var fetchFailed: Bool = false
  @Published public var isRefreshing: Bool = false
  @Published public var showOnlineAdvocates: Bool = false
  @Published public var showCategories: Bool = false
  @Published public var showAlert: Bool = false
  @Published public var unauthorized: Bool = false
  @Published public var alertMessage: String = ""
  @Published public var showConnectionAlert: Bool = false
  @Published public var isPresentSheet: Bool = false
  @Published public var ongoingConsultation: Bool = false
  @Published public var articleSelectedID: Int = 1
  @Published public var isLoggedIn: Bool = false
  @Published public var name: String = ""
  @Published public var topAdvocateMonth: String = ""
  @Published public var isCategorySheetPresented: Bool = false
  @Published public var isConsultationNowSheetPresented: Bool = false
  @Published public var selectedSkill: AdvocateSkills?
  @Published public var hideTabBar: Bool = false
  @Published public var arrayOfuserCases: [UserCases] = []
  @Published public var userCases: UserCases = .init()
  @Published public var isPresentPromotionBanner: Bool = false
  @Published public var showShimmer: Bool = false
  @Published public var sktmModel: ClientGetSKTM? = nil
  @Published public var isPresentReasonBottomSheet: Bool = false
  @Published public var reasons: [ReasonEntity] = []
  @Published public var isPresentRefundBottomSheet: Bool = false
  @Published public var price: String = ""
  @Published public var meViewModel: MeViewModel = .init()
  
  //Variables
  
  private var socket: AprodhitKit.SocketServiceProtocol!
  private var userSessionData: UserSessionData? = nil
  private var client: DataOPClient? = nil
  private var subscriptions = Set<AnyCancellable>()
  private var paymentStatus: PaymentStatusViewModel = .init()
  public var promotionBannerViewModel: BannerPromotionViewModel = .init()
  public var selectedReason: ReasonEntity? = nil
  public var reason: String? = nil
  public var idCardEntity: IDCardEntity = .init()
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    homeRepository: HomeRepositoryLogic,
    ongoingRepository: OngoingRepositoryLogic,
    sktmRepository: SKTMRepositoryLogic,
    idCardRepository: GetKTPDataRepositoryLogic,
    cancelationRepository: PaymentCancelationRepositoryLogic,
    meRepository: MeRepositoryLogic,
    onlineAdvocateNavigator: OnlineAdvocateNavigator,
    topAdvocateNavigator: TopAdvocateNavigator,
    articleNavigator: ArticleNavigator,
    searchNavigator: SearchNavigator,
    categoryNavigator: CategoryNavigator,
    advocateListNavigator: AdvocateListNavigator,
    sktmNavigator: SKTMNavigator,
    mainTabBarResponder: MainTabBarResponder,
    ongoingNavigator: OngoingNavigator,
    loginResponder: LoginResponder,
    refundNavigator: RefundNavigator,
    probonoNavigator: ProbonoNavigator
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.homeRepository = homeRepository
    self.ongoingRepository = ongoingRepository
    self.sktmRepository = sktmRepository
    self.idCardRepository = idCardRepository
    self.cancelationRepository = cancelationRepository
    self.meRepository = meRepository
    self.onlineAdvocateNavigator = onlineAdvocateNavigator
    self.topAdvocateNavigator = topAdvocateNavigator
    self.articleNavigator = articleNavigator
    self.searchNavigator = searchNavigator
    self.categoryNavigator = categoryNavigator
    self.advocateListNavigator = advocateListNavigator
    self.sktmNavigator = sktmNavigator
    self.mainTabBarResponder = mainTabBarResponder
    self.ongoingNavigator = ongoingNavigator
    self.loginResponder = loginResponder
    self.refundNavigator = refundNavigator
    self.probonoNavigator = probonoNavigator
    
    Task {
      await requestPromotionBanner()
      checkPromotionBaner()
    }
    
    Task {
      showShimmer = true
      let result = await fetchUserSessionData()
      
      if let session = result {
        isLoggedIn = true
        userSessionData = session
        client = Prefs.getClient()
        name = client?.name ?? ""
      } else {
        isLoggedIn = false
        name = ""
      }
      
      await fetchOngoingUserCases()
      await fetchAllAPI()
      await fetchProbonoStatus()
      showShimmer = false
    }
    
    observer()
  }
  
  //MARK: - Socket
  
  public func startSocket() {
    socket = AprodhitKit.SocketServiceImpl(socketURL: Environment.shared.socketURL)
    guard let socket = socket as? AprodhitKit.SocketServiceImpl else { return }
    socket.delegate = self
    socket.start()
  }
  
  public func stopSocket() {
    if let socket = socket {
      socket.stop()
    }
  }
  
  //MARK: - Fetch Data from Local
  
  private func fetchUserSessionData() async -> UserSessionData? {
    do {
      return try await userSessionDataSource.fetchData()
    } catch {
      return nil
    }
  }
  
  private func endUserSession() {
    Task {
      let removed = try? await userSessionDataSource.deleteData()
      if let _ = removed {
        userSessionData = nil
        isLoggedIn = false
        name = ""
      }
    }
    
    Prefs.removeClient()
    Prefs.removeSession()
    
  }
  
  //MARK: - Fetch Data from API
  
  @MainActor
  public func requestMe() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken
      else {
        GLogger(.info, layer: "Presentation", message: "token nil")
        return
      }
      
      let entity = try await meRepository.requestMe(headers: HeaderRequest(token: token))
      meViewModel = BioEntity.mapTo(entity)
    } catch {
      guard let error = error as? ErrorMessage
      else {
        return
      }
      
      indicateError(error: error)
    }
  }
  
  public func fetchAllAPI() async {
    async let advocateViewModels = fetchOnlineAdvocates()
    async let skillViewModels = fetchSkills()
    async let (topAdvocatesVewModels, topAgencyCitiesViewModels) = fetchTopAdvocates()
    async let categoryViewModels = fetchArticleCategory()
    async let articleViewModels = fetchNewestArticle()
    
    onlinedAdvocates = await advocateViewModels
    skills = await skillViewModels
    topAdvocates = await topAdvocatesVewModels
    topAgencies = await topAgencyCitiesViewModels
    categories = await categoryViewModels
    articles = await articleViewModels
  }
  
  public func fetchOnlineAdvocates() async -> [Advocate] {
    var advocates: [Advocate] = []
    
    do {
      let params = AdvocateParamRequest(isOnline: true)
      let items = try await homeRepository.fetchOnlineAdvocates(params: params)
      showOnlineAdvocates = true
      
      if items.count > 5 {
        for i in 0..<5 {
          advocates.append(items[i])
        }
        return advocates
      }
      
      advocates = items
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      
      indicateError(error: error)
    }
    
    return advocates
  }
  
  private func fetchSkills() async -> [AdvocateSkills] {
    var skillViewModels: [AdvocateSkills] = []
    
    do {
      let model = try await homeRepository.fetchSkills(params: nil)
      skillViewModels = model
      showCategories = true
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      
      indicateError(error: error)
    }
    
    return skillViewModels
  }
  
  public func fetchTopAdvocates() async -> ([TopAdvocateViewModel], [TopAgencyViewModel]) {
    var advocates: [TopAdvocateViewModel] = []
    var agencies: [TopAgencyViewModel] = []
    do {
      let (dataEntity, advocateEntities, agencyEntities) = try await homeRepository.fetchTopAdvocates()
      topAdvocateMonth = dataEntity.getPeriode()
      advocates = advocateEntities.map(TopAdvocateEntity.mapTo(_:))
      agencies = agencyEntities.map(TopAgencyEntity.mapTo(_:))
    } catch {
      guard let error = error as? ErrorMessage
      else { return ([], []) }
      indicateError(error: error)
    }
    
    return (advocates, agencies)
  }
  
  public func fetchArticleCategory() async -> [CategoryArticleViewModel] {
    var viewModels: [CategoryArticleViewModel] = []
    
    do {
      let entities = try await homeRepository.fetchCategoryArticle()
      viewModels = entities.map(CategoryArticleEntity.mapTo(_:))
      viewModels.insert(
        CategoryArticleViewModel(
          id: 111,
          name: "Terbaru",
          niceName: "terbaru",
          selected: true
        ),
        at: 0
      )
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      
      indicateError(error: error)
    }
    
    return viewModels
    
  }
  
  public func fetchArticle(with name: String) async -> [ArticleViewModel] {
    var viewModels: [ArticleViewModel] = []
    do {
      let entities = try await homeRepository.fetchArticles(params: ArticleParamRequest(name: name))
      viewModels = entities.map(ArticleEntity.mapTo(_:))
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      indicateError(error: error)
    }
    
    return viewModels
  }
  
  private func fetchNewestArticle() async -> [ArticleViewModel] {
    var viewModels: [ArticleViewModel] = []
    do {
      let entities = try await homeRepository.fetchNewestArticle()
      viewModels = entities.map(ArticleEntity.mapTo(_:))
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      indicateError(error: error)
    }
    
    return viewModels
  }
  
  private func fetchSKTM() async {
    guard let data = userSessionData else { return }
    do {
      sktmModel = try await sktmRepository.fetchSKTM(
        headers: HeaderRequest(token: data.remoteSession.remoteToken).toHeaders()
      )
    } catch {
      if let error = error as? ErrorMessage {
        indicateError(error: error)
      }
    }
  }
  
  public func fetchOngoingUserCases() async {
    
    guard let data = userSessionData else {
      return
    }
    
    do {
      arrayOfuserCases = try await ongoingRepository.fetchOngoingUserCases(
        headers: HeaderRequest(token: data.remoteSession.remoteToken).toHeaders(),
        parameters: UserCasesParamRequest(type: "ongoing")
      )
      
      ongoingConsultation = !arrayOfuserCases.isEmpty
      Prefs.saveConsultStatus(isConsult: !arrayOfuserCases.isEmpty)
      
      guard !arrayOfuserCases.isEmpty else { return }
      userCases = arrayOfuserCases[0]
      
      await processWaitingForPayment(userCases)
      
    } catch {
      if let error = error as? ErrorMessage {
        indicateError(error: error)
      }
    }
    
  }
  
  private func getPaymentStatus() async {
    
    guard let data = userSessionData else {
      return
    }
    do {
      let entity = try await homeRepository.fetchPaymentStatus(
        headers: HeaderRequest(token: data.remoteSession.remoteToken).toHeaders(),
        parameters: .init(orderNumber: userCases.order_no ?? "")
      )
      
      paymentStatus = PaymentStatusEntity.mapTo(entity)
      
    } catch {
      if let error = error as? ErrorMessage {
        indicateError(error: error)
      }
    }
    
  }
  
  public func requestPromotionBanner() async {
    do {
      let entity = try await homeRepository.fetchPromotionBanner()
      promotionBannerViewModel = BannerPromotionEntity.mapTo(entity)
    } catch {
      if let error = error as? ErrorMessage {
        indicateError(error: error)
      }
    }
  }
  
  public func onRefresh() async {
    indicateLoading()
    hideTabBar = true
    
    let result = await fetchUserSessionData()
    
    if let session = result {
      isLoggedIn = true
      userSessionData = session
      client = Prefs.getClient()
      name = client?.name ?? ""
    } else {
      isLoggedIn = false
      name = ""
    }
    
    await fetchAllAPI()
    await fetchOngoingUserCases()
    await fetchProbonoStatus()
    await requestMe()
    await checkBottomSheet()
    
    indicateSuccess(message: "")
    hideTabBar = false
  }
  
  private func fetchProbonoStatus() async {
    idCardRepository
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
  public func requestReasons() async {
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        return
      }
      reasons = try await cancelationRepository.requestReasons(headers: HeaderRequest(token: token))
      indicateSuccess()
    } catch {
      guard let error = error as? ErrorMessage else { return }
      indicateError(error: error)
    }
  }
  
  @MainActor
  private func dismissRefundPopup() async -> Bool {
    var success: Bool = false
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        indicateError(message: "")
        return false
      }
      
      success = try await cancelationRepository.requestDismissRefund(
        headers: HeaderRequest(token: token),
        parameters: DismissRefundRequest(id: meViewModel.consultationID)
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
  private func sendCancelationReason() async -> Bool {
    indicateLoading()
    var success: Bool = false
    
    do {
      guard let token = userSessionData?.remoteSession.remoteToken else {
        indicateError(message: "")
        return false
      }
      
      success = try await cancelationRepository.requestCancelReason(
        headers: HeaderRequest(token: token),
        parameters: CancelPaymentRequest(
          orderNumber: meViewModel.orderNumber,
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
  
  //MARK: - Other function
  
  @MainActor
  public func requestCancelReason() async {
    if await sendCancelationReason() {
      hideReasonBottomSheet()
    }
  }
  
  public func appsflyerConnect() {
    
  }
  
  public func checkPromotionBaner() {
    if Prefs.getStatusBanner() {
      showPromotionBanner()
    }
  }
  
  @MainActor
  public func requestDismissRefundPopup() async {
    await dismissRefundPopup()
  }
  
  public func getFourTopAdvocates() -> [TopAdvocateViewModel] {
    if !topAdvocates.isEmpty {
      var topAdvocates = topAdvocates[0 ..< topAdvocates.index(after: 3)]
      topAdvocates.append(
        TopAdvocateViewModel(
          position: 0,
          id: 0,
          image: "",
          name: "",
          agency: "",
          experience: 0
        )
      )
      
      return Array(topAdvocates)
    }
    return []
  }
  
  public func selectCategory(_ id: Int, name: String) async {
    
    for i in 0 ..< categories.count {
      if categories[i].id == id {
        categories[i].setSelected(true)
      } else {
        categories[i].setSelected(false)
      }
    }
    
    if id == 111 {
      articles = await fetchNewestArticle()
      return
    }
    
    articles = await fetchArticle(with: name)
    
  }
  
  func findOnProcessUserCasses(userCase: UserCases) -> Bool {
    if userCase.status == "ON_PROCESS" || userCase.status == "WAITING_FOR_APPROVAL"
        || userCase.status == "WAITING_FOR_PAYMENT" || userCase.status == "REJECTED"
        || userCase.status == "CLIENT_CANCELED" || userCase.status == "LAWYER_MISSED_CALL"
        || userCase.status == "ORDER_PENDING" {
      return true
    }
    return false
  }
  
  func findOnProcessUserCassesFailed(userCase: UserCases) -> Bool {
    if userCase.status == "REJECTED"
        || userCase.status == "CLIENT_CANCELED"
        || userCase.status == "LAWYER_MISSED_CALL" {
      return true
    }
    return false
  }
  
  private func processWaitingForPayment(_ item: UserCases) async {
    
    if item.status == Constant.Home.Text.WAITING_FOR_PAYMENT
        && !item.order_no!.isEmpty {
      
      await getPaymentStatus()
    }
    
  }
  
  private func processSKTMAndReplaceOnlineLawyerState(_ status: String) {
    
    var arrayOfAdvocates: [Advocate] = onlinedAdvocates
    
    if status == Constant.Home.Text.ACTIVE {
      for i in 0 ..< arrayOfAdvocates.count {
        //MARK: need to fix
        //arrayOfAdvocates[i].is_probono = true
      }
      
      onlinedAdvocates = arrayOfAdvocates
    }
  }
  
  public func getImageURL() -> URL? {
    return userCases.lawyer?.getImageName()
  }
  
  public func getLawyersName() -> String {
    return userCases.lawyer?.getName() ?? ""
  }
  
  public func checkBottomSheet() async {
    if !meViewModel.orderNumber.isEmpty {
      await requestReasons()
      showReasonBottomSheet()
    }
    
    if meViewModel.consultationID != 0 {
      await requestDismissRefundPopup()
      showRefundBottomSheet()
    }
    
  }
  
  public func probonoTitle() -> AttributedString {
    let text = "3x Konsultasi Gratis dengan Pro bono"
    var attributedString = AttributedString(text)
    let firstRange = attributedString.range(of: "3x Konsultasi Gratis")!
    let range = attributedString.range(of: "dengan Pro bono")!
    attributedString.foregroundColor = .darkTextColor
    attributedString[firstRange].font = .lexendFont(style: .title(size: 10))
    attributedString[range].font = .lexendFont(style: .body(size: 10))
    
    return attributedString
  }
  
  public func actionTitle() -> AttributedString {
    let text = "Pelajari"
    var attributedString = AttributedString(text)
    attributedString.foregroundColor = .buttonActiveColor
    attributedString.font = .lexendFont(style: .title(size: 12))
    
    return attributedString
  }
  
  //MARK: - Indicator
  
  private func indicateLoading() {
    isLoading = true
    isRefreshing = false
  }
  
  private func indicateError(message: String) {
    isLoading = false
    isRefreshing = false
    showAlert = true
    alertMessage = message
    showShimmer = false
  }
  
  private func indicateError(error: ErrorMessage) {
    guard error.id == -6 else {
      indicateError(message: error.message)
      return
    }
    
    isLoading = false
    unauthorized = true
  }
  
  private func indicateSuccess(message: String) {
    isLoading = false
    isRefreshing = false
  }
  
  private func indicateSuccess() {
    isLoading = false
    isRefreshing = false
  }
  
  public func dismissAlert() {
    if unauthorized {
      NLog(
        .info,
        layer: "Presentation",
        message: "Logout session"
      )
    }
  }
  
  public func showPromotionBanner() {
    isPresentPromotionBanner = true
  }
  
  public func dismissPromotionBanner() {
    isPresentPromotionBanner = false
  }
  
  public func showReasonBottomSheet() {
    isPresentReasonBottomSheet = true
    hideTabBar = true
  }
  
  public func hideReasonBottomSheet() {
    isPresentReasonBottomSheet = false
    hideTabBar = false
  }
  
  //MARK: - Navigator
  
  public func navigateToSeeAllAdvocate() {
    onlineAdvocateNavigator.navigateToListAdvocate(
      categoryAdvocate: "",
      listCategoryID: [],
      listSkillAdvocate: [],
      listingType: "GENERAL",
      sktmModel: sktmModel
    )
  }
  
  public func navigateToDetailAdvocate(_ advocate: Advocate) {
    let index = onlinedAdvocates.firstIndex { i in
      advocate.id == i.id
    }!
    onlineAdvocateNavigator.navigateToAdvocateDetail(
      index: Int(index),
      advocates: onlinedAdvocates,
      sktmModel: sktmModel
    )
  }
  
  public func navigateToDetailTopAdvocate() {
    topAdvocateNavigator.navigateToDetailTopLawyerAndAgency()
  }
  
  public func navigateToDetailArticle(id: Int) {
    let article = articles.filter { $0.id == id }.first!
    articleNavigator.navigateToDetailArticle(
      title: article.title,
      imageURL: article.getArticleImage(),
      content: article.content
    )
  }
  
  public func navigateToSearch(with text: String) {
    searchNavigator.navigateToAdvocateListInSearchMode(
      searchText: text,
      sktmModel: sktmModel
    )
  }
  
  public func navigateToDetailCategory() {
    categoryNavigator.navigateToDetailCategory(skills)
  }
  
  public func navigateToAdvocateListWithSkill() {
    if let skill = selectedSkill {
      advocateListNavigator.navigateToAdvocateListWithSkill(
        categoryAdvocate: skill.skillName,
        listCategoryId: [skill.getID()],
        listSkillAdvocate: skills,
        listingType: Constant.Text.GENERAL,
        sktmModel: nil
      )
      return
    }
    
    advocateListNavigator.navigateToAdvocateListWithSkill(
      categoryAdvocate: "",
      listCategoryId: [],
      listSkillAdvocate: skills,
      listingType: Constant.Text.GENERAL,
      sktmModel: nil
    )
  }

  public func navigateToAdvocateList() {
    advocateListNavigator.navigateToAdvocateList(
      listingType: Constant.Text.GENERAL,
      sktmModel: sktmModel
    )
  }
  
  public func navigateToBlog() {
    advocateListNavigator.navigateToBlog()
  }
  
  public func navigateToDetailSKTM() {
    guard let _ = userSessionData else {
      sktmNavigator.navigateToUploadSKTM()
      return
    }
    
    guard let status = sktmModel?.data?.status else {
      sktmNavigator.navigateToUploadSKTM()
      return
    }
    
    if status == "ON_PROCESS" || status == "ACTIVE"
        || status == "EMPTY_QUOTA" || status == "EXPIRED"
        || status == "FAILED" {
      
      sktmNavigator.navigateToDetailSKTM(sktmModel)
    } else {
      sktmNavigator.navigateToUploadSKTM()
    }
    
  }
  
  public func navigateToDecisionTree() {
    sktmNavigator.navigateDecisionTree(sktmModel)
  }
  
  public func navigateToUploadSKTM() {
    sktmNavigator.navigateToUploadSKTM()
  }
  
  public func navigateToProbonoService() {
    probonoNavigator.navigateToProbonoService(
      page: Constant.Page.HOME,
      skills: skills
    )
  }
  
  public func switchToProfile() {
    mainTabBarResponder.gotoProfile()
  }
  
  public func navigateToWaitingRoom(isProbono: Bool) {
    ongoingNavigator.navigateToWaitingRoom(
      userCases,
      roomkey: userCases.room_key ?? "",
      consultId: userCases.booking?.consultation_id ?? 0,
      status: findOnProcessUserCassesFailed(userCase: userCases),
      paymentCategory: .VA,
      isProbono: isProbono
    )
  }
  
  public func navigateToConsultationChat() {
    ongoingNavigator.navigateToConsultationChat(
      userCases,
      clientID: client?.relation?.id ?? 0,
      clientName: client?.relation?.name ?? ""
    )
  }
  
  public func navigateToPayment() {
    if let _ = paymentStatus.getPaymentURL() {
      openURL()
      return
    }
    
    
    let lawyerInfoViewModel = LawyerInfoViewModel(
      id: userCases.id ?? 0,
      imageURL: URL(string: userCases.lawyer?.photo_url ?? ""),
      name: userCases.lawyer?.getName() ?? "",
      agency: userCases.lawyer?.agency_name ?? "",
      price: userCases.getPrice(),
      originalPrice: userCases.lawyer?.getOriginalPrice() ?? "",
      isDiscount: userCases.lawyer?.isDiscount ?? false,
      isProbono: userCases.service_type ?? "" == Constant.Home.Text.PROBONO,
      orderNumber: userCases.order_no ?? "",
      detailIssues: userCases.description ?? "",
      //MARK: need to set again
      category: "Pidana",
      type: "Chat saja",
      duration: "60 menit"
      
    )
    
    ongoingNavigator.navigateToPayment(lawyerInfoViewModel)
  }
  
  public func openURL() {
    ongoingNavigator.navigateToPaymentURL(paymentStatus.getPaymentURL())
  }
  
  public func navigateToLogin() {
    loginResponder.gotoToLogin()
  }
  
  public func navigateToRefundForm() {
    refundNavigator.navigateToForm(
      meViewModel.consultationID,
      userCases: userCases
    )
  }
  
  public func gotoHistoryConsultation() {
    mainTabBarResponder.gotoHistory()
  }
  
  //MARK: - BottomSheet
  
  func showCategoryBottomSheet() {
    isCategorySheetPresented = true
    hideTabBar = true
  }
  
  func showConsultationNowBottomSheet() {
    isConsultationNowSheetPresented = true
    hideTabBar = true
  }
  
  func hideConsultationNowBottomSheet() {
    isConsultationNowSheetPresented = false
    hideTabBar = false
  }
  
  func hideCategoryBottomSheet() {
    isCategorySheetPresented = false
    hideTabBar = false
  }
  
  func showRefundBottomSheet() {
    Task {
      try await Task.sleep(nanoseconds: 2 * 1_000_000)
      isPresentRefundBottomSheet = true
    }
  }
  
  func hideRefundBottomSheet() {
    isPresentRefundBottomSheet = true
  }
  
  //MARK: - Observer
  
  private func observer() {
    $unauthorized
      .dropFirst()
      .filter { $0 == true }
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] _ in
        guard let self = self else { return }
        endUserSession()
      }.store(in: &subscriptions)
    
    $sktmModel
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { model in
        if let status = model?.data?.status {
          self.processSKTMAndReplaceOnlineLawyerState(status)
        }
      }.store(in: &subscriptions)
  }
  
}

public protocol HomeStoreFactory {
  
  func makeHomeStore() -> HomeStore
  
}

@MainActor
extension HomeStore: AprodhitKit.SocketServiceDelegate {
  
  nonisolated public func didPaymentUpdate() {
    GLogger(
      .info,
      layer: "Presentation",
      message: "Did Payment Updated"
    )
  }
  
  nonisolated public func didSKTMUpdate() {
    //    self.isUpdateSKTM = true
    Task {
      await fetchSKTM()
    }
    
  }
  
  nonisolated public func didLawyerEndConsult() {
    Task {
      await fetchOngoingUserCases()
    }
  }
  
  nonisolated public func didLawyerJoinRoom(data: NSDictionary) {
    Task {
      await fetchOngoingUserCases()
    }
  }
  
  nonisolated public func didLawyerReject(data: NSDictionary) {
    Task {
      await fetchOngoingUserCases()
    }
    
    GLogger(
      .info,
      layer: "Presentation",
      message: "⚡️ socket lawyer reject"
    )
    
  }
  
  nonisolated public func didLawyerRecall() {
    print("lawyer recall succes")
  }
  
  public func onConnected() {
    guard let socket = socket,
          let token = userSessionData?.remoteSession.remoteToken,
          let clientID = client?.relation?.id
    else {
      print("⚡️ socket could not registerd")
      return
    }
    
    socket.register(
      token: token,
      id: clientID
    )
  }
  
  public func didUpdateOnlineLawyer() {
    Task {
      onlinedAdvocates = await fetchOnlineAdvocates()
    }
    
    GLogger(
      .info,
      layer: "Presentation",
      message: "⚡️ socket update online lawyer"
    )
    
  }
  
}
