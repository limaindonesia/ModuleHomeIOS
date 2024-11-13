//
//  HomeStoreTests.swift
//
//
//  Created by Ilham Prabawa on 20/07/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import Alamofire
import GnDKit
import Network

final class HomeStoreTests: XCTestCase {

  var sut: HomeStore!

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  @MainActor
  func makeHomeStore(
    repository: HomeRepositoryLogic & SKTMRepositoryLogic & OngoingRepositoryLogic,
    navigator: MockNavigator
  ) -> HomeStore {
    return HomeStore(
      userSessionDataSource: MockUserSessionDataSource(),
      repository: repository,
      ongoingRepository: repository,
      sktmRepository: repository,
      onlineAdvocateNavigator: navigator,
      topAdvocateNavigator: navigator,
      articleNavigator: navigator,
      searchNavigator: navigator,
      categoryNavigator: navigator,
      advocateListNavigator: navigator,
      sktmNavigator: navigator,
      mainTabBarResponder: navigator,
      ongoingNavigator: navigator,
      loginResponder: navigator
    )
  }
  
  @MainActor
  func test_fetchOnlineAdvocates_andArrayofAdvocatesShouldBeFilled() async {
    //given
    let mockRepository = MockHomeRepository()
    let mockNavigator = MockNavigator()
    sut = makeHomeStore(
      repository: mockRepository,
      navigator: mockNavigator
    )

    //when
    sut.onlinedAdvocates = await sut.fetchOnlineAdvocates()

    //then
    XCTAssertEqual(sut.onlinedAdvocates.count, 3)
  }

  @MainActor
  func test_navigateTo_listOfOnlinedAdvocates() async {
    //given
    let mockRepository = MockHomeRepository()
    let mockNavigator = MockNavigator()
    sut = makeHomeStore(
      repository: mockRepository,
      navigator: mockNavigator
    )

    //when
    sut.navigateToSeeAllAdvocate()

    //then
    XCTAssertTrue(mockNavigator.pushListOnlineAdvocates)
  }

  @MainActor
  func test_fetchOnlineAdvocates_andShouldReturnNetworkErrorMessage() async {
    //given
    let mockService = MockNetworkService()
    let mockError = NetworkErrorMessage(code: -1, description: "mock error")
    mockService.mockError = mockError
    let remoteDataSource = HomeRemoteDataSourceImpl(service: mockService)
    let repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    _ = await sut.fetchOnlineAdvocates()

    //then
    XCTAssertEqual(sut.alertMessage, mockError.description)
    XCTAssertFalse(sut.unauthorized)
  }

  @MainActor
  func test_fetchOnlineAdvocates_andReturn_unauhtorizedStatus() async {
    //given
    let mockService = MockNetworkService()
    let mockError = NetworkErrorMessage(code: -6, description: "Unathorized")
    mockService.mockError = mockError

    let remoteDataSource = HomeRemoteDataSourceImpl(service: mockService)
    let repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    _ = await sut.fetchOnlineAdvocates()

    //then
    XCTAssertTrue(sut.unauthorized)
  }

  @MainActor
  func test_fetchCategory_andReturn_arrayOfCategories() async {
    //given
    let json = try? loadJSONFromFile(filename: "lawyer-skills", inBundle: .module)
    let service = MockNetworkService()
    service.mockData = json

    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
   
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    sut.categories = await sut.fetchArticleCategory()

    //then
    XCTAssertEqual(sut.categories.count, 8)
  }

  @MainActor
  func test_fetchCategory_shouldFailure() async {
    //given
    let service = MockNetworkService()
    service.mockError = NetworkErrorMessage(code: -5, description: "Bad Horsie")

    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    _ = await sut.fetchArticleCategory()

    //then
    XCTAssertEqual(sut.alertMessage, "Bad Horsie")
  }

  @MainActor
  func test_fetchAllApi_withParallel_shouldLoadWithoutOrder() async {
    //given
    let remote = FakeHomeRemoteDataSource()
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )
    
    //when
    let fetchTask = Task { await sut.fetchAllAPI() }

    await fetchTask.value

    //then
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.categories.count, 16)
    XCTAssertEqual(sut.onlinedAdvocates.count, 4)
    XCTAssertEqual(sut.topAdvocates.count, 10)
    XCTAssertEqual(sut.topAgencies.count, 3)
    XCTAssertEqual(sut.articles.count, 10)

  }

  @MainActor
  func test_fetchAllApi_withParallel_shouldThrowError() async {
    //given
    let service = MockNetworkService()
    do {
      service.mockData = try loadJSONFromFile(filename: "error", inBundle: .module)
    } catch {
      guard let error = error as? NetworkErrorMessage else { return }
      service.mockError = error
    }

    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    await sut.fetchAllAPI()

    //then
    XCTAssertEqual(sut.alertMessage, "Data Not Found")

  }

  @MainActor
  func test_fetchTopAdvocate_shouldReturnSuccess() async {
    //given
    let data = try? loadJSONFromFile(filename: "top_advocates", inBundle: .module)
    let service = MockNetworkService()
    service.mockData = data

    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    let (topAdvocate, _) = await sut.fetchTopAdvocates()
    sut.topAdvocates = topAdvocate

    //then
    XCTAssertEqual(sut.topAdvocates.count, 10)
  }

  @MainActor
  func test_fetchTopAdvocate_shouldReturnErrorMessage() async {
    //given
    let service = MockNetworkService()
    service.mockError = NetworkErrorMessage(code: 1, description: "Bad Horsie")
    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )
    //when
    _ = await sut.fetchTopAdvocates()

    //then
    XCTAssertEqual(sut.alertMessage, "Bad Horsie")
  }

  @MainActor
  func test_fetchTopAgency_shouldReturnSuccess() async {
    //given
    let data = try? loadJSONFromFile(filename: "top_advocates", inBundle: .module)
    let service = MockNetworkService()
    service.mockData = data

    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    let (_, topAgencies) = await sut.fetchTopAdvocates()
    sut.topAgencies = topAgencies

    //then
    XCTAssertEqual(sut.topAgencies.count, 3)
  }

  @MainActor
  func test_fetchTopAgency_shouldReturnErrorMessage() async {
    //given
    let service = MockNetworkService()
    service.mockError = NetworkErrorMessage(code: 1, description: "Bad Horsie")
    let remote = HomeRemoteDataSourceImpl(service: service)
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    _ = await sut.fetchTopAdvocates()

    //then
    XCTAssertEqual(sut.alertMessage, "Bad Horsie")
  }

  @MainActor
  func test_fetchArticle_shouldReturnSuccess() async {
    //given
    let remote = FakeHomeRemoteDataSource()
    let repository = HomeRepositoryImpl(remoteDataSource: remote)
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: repository,
      navigator: mockNavigator
    )

    //when
    sut.articles = await sut.fetchArticle(with: "")

    //then
    XCTAssertEqual(sut.articles.count, 10)
  }

  @MainActor
  func test_fetchArticle_andCheckFirstID_shouldBeOne() async {
    //given
    let mockRepository = MockHomeRepository()
    let mockNavigator = MockNavigator()
    
    sut = makeHomeStore(
      repository: mockRepository,
      navigator: mockNavigator
    )

    //when
    sut.articles = await sut.fetchArticle(with: "")

    //then
    XCTAssertEqual(sut.articles.map{ $0.id }.first!, 0)
  }

  /*@MainActor
   func test_initStore_butNoConnection_shouldShowInformation() {
   //given
   let monitor = NWPathMonitor()

   let remote = FakeHomeRemoteDataSource()
   let repository = HomeRepositoryImpl(remoteDataSource: remote)
   let mockNavigator = MockNavigator()


   sut = HomeStore(
   repository: repository,
   onlineAdvocateNavigator: mockNavigator
   )

   //when
   monitor.pathUpdateHandler = { path in
   self.sut.showConnectionAlert = path.status == .unsatisfied
   }

   let cellular = NWPathMonitor(requiredInterfaceType: .cellular)
   monitor.pathUpdateHandler?(cellular.currentPath)

   //then
   XCTAssertTrue(sut.showConnectionAlert)

   }*/

}
