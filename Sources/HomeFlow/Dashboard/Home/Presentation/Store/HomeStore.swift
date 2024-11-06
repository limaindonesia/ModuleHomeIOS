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
  private let repository: HomeRepositoryLogic
  private let sktmRepository: SKTMRepositoryLogic
  private let userSessionDataSource: UserSessionDataSourceLogic
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
  @Published public var selectedSkill: AdvocateSkills?
  @Published public var hideTabBar: Bool = false
  @Published public var arrayOfuserCases: [UserCases] = []
  @Published public var userCases: UserCases = .init()
  @Published public var isPresentPromotionBanner: Bool = false
  @Published public var showShimmer: Bool = false
  @Published public var sktmModel: ClientGetSKTM? = nil
  
  //Variables
  private var socket: AprodhitKit.SocketServiceProtocol!
  private var userSessionData: UserSessionData? = nil
  private var client: DataOPClient? = nil
  private var subscriptions = Set<AnyCancellable>()
  private var paymentStatus: PaymentStatusViewModel = .init()
  public var promotionBannerViewModel: BannerPromotionViewModel = .init()
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    repository: HomeRepositoryLogic,
    sktmRepository: SKTMRepositoryLogic,
    onlineAdvocateNavigator: OnlineAdvocateNavigator,
    topAdvocateNavigator: TopAdvocateNavigator,
    articleNavigator: ArticleNavigator,
    searchNavigator: SearchNavigator,
    categoryNavigator: CategoryNavigator,
    advocateListNavigator: AdvocateListNavigator,
    sktmNavigator: SKTMNavigator,
    mainTabBarResponder: MainTabBarResponder,
    ongoingNavigator: OngoingNavigator,
    loginResponder: LoginResponder
  ) {
    
    self.userSessionDataSource = userSessionDataSource
    self.repository = repository
    self.sktmRepository = sktmRepository
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
      await fetchSKTM()
      
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
    
  }
  
  //MARK: - Fetch Data from API
  
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
      let items = try await repository.fetchOnlineAdvocates(params: params)
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
      let model = try await repository.fetchSkills(params: nil)
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
      let (dataEntity, advocateEntities, agencyEntities) = try await repository.fetchTopAdvocates()
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
      let entities = try await repository.fetchCategoryArticle()
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
      let entities = try await repository.fetchArticles(params: ArticleParamRequest(name: name))
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
      let entities = try await repository.fetchNewestArticle()
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
        headers: ["Authorization" : "Bearer \(data.remoteSession.remoteToken)"]
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
      arrayOfuserCases = try await repository.fetchOngoingUserCases(
        headers: ["Authorization" : "Bearer \(data.remoteSession.remoteToken)"],
        parameters: UserCasesParamRequest(type: "ongoing")
      )
      
      ongoingConsultation = !arrayOfuserCases.isEmpty
      
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
      let entity = try await repository.fetchPaymentStatus(
        headers: ["Authorization" : "Bearer \(data.remoteSession.remoteToken)"],
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
      let entity = try await repository.fetchPromotionBanner()
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
    await fetchSKTM()
    
    indicateSuccess(message: "")
    hideTabBar = false
  }
  
  //MARK: - Other function
  
  public func appsflyerConnect() {
    
  }
  
  public func checkPromotionBaner() {
    if Prefs.getStatusBanner() {
      showPromotionBanner()
    }
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
        arrayOfAdvocates[i].is_probono = true
      }
      
      onlinedAdvocates = arrayOfAdvocates
    }
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
    guard let skill = selectedSkill else { return }
    advocateListNavigator.navigateToAdvocateListWithSkill(
      categoryAdvocate: skill.skillName,
      listCategoryId: [skill.getID()],
      listSkillAdvocate: skills,
      listingType: Constant.Text.GENERAL,
      sktmModel: sktmModel
    )
  }
  
  public func navigateToAdvocateList() {
    advocateListNavigator.navigateToAdvocateList(
      listingType: Constant.Text.GENERAL,
      sktmModel: sktmModel
    )
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
  
  public func switchToProfile() {
    mainTabBarResponder.gotoProfile()
  }
  
  public func navigateToWaitingRoom() {
    ongoingNavigator.navigateToWaitingRoom(
      userCases,
      roomkey: userCases.room_key ?? "",
      consultId: userCases.booking?.consultation_id ?? 0,
      status: findOnProcessUserCassesFailed(userCase: userCases)
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
    
    ongoingNavigator.navigateToPayment(userCases)
  }
  
  public func openURL() {
    ongoingNavigator.navigateToPaymentURL(paymentStatus.getPaymentURL())
  }
  
  public func navigateToLogin() {
    loginResponder.gotoToLogin()
  }
  
  //MARK: - BottomSheet
  
  func showCategoryBottomSheet() {
    isCategorySheetPresented = true
    hideTabBar = true
  }
  
  func hideCategoryBottomSheet() {
    isCategorySheetPresented = false
    hideTabBar = false
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
