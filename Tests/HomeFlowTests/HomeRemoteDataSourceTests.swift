//
//  HomeRemotesDataSourceTests.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import Alamofire
import Combine
import GnDKit

final class HomeRemoteDataSourceTests: XCTestCase {

  var sut: HomeRemoteDataSourceLogic!

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func test_fetchOnlineAdvocate_andReturnModel() async throws {
    //given
    let service = MockNetworkService()
    sut = HomeRemoteDataSourceImpl(service: service)
    let jsonResponse = """
    {
      "success": true
    }
    """.data(using: .utf8)!

    service.mockData = jsonResponse
    var result: AdvocateGetResp!
    let params = AdvocateParamRequest(isOnline: true)

    //when
    result = try await sut.fetchOnlineAdvocates(params: params.toParam())

    //then
    let success = try XCTUnwrap(result.success)
    XCTAssertTrue(success)

  }

  func test_fetchOnlineAdvocate_andThrowError() async throws {
    //given
    let service = MockNetworkService()
    sut = HomeRemoteDataSourceImpl(service: service)
    service.mockError = NetworkErrorMessage(code: -1, description: "should error")
    var nError: NetworkErrorMessage!
    let params = AdvocateParamRequest(isOnline: true)

    //when
    do {
      _ = try await sut.fetchOnlineAdvocates(params: params.toParam())
      XCTFail("expected error to be thrown")
    } catch {
      nError = error as? NetworkErrorMessage
    }

    //then
    XCTAssertEqual(nError.description, "should error")

  }

  func test_fetchCategories_shouldReturnSuccess() async throws {
    //given
    let service = MockNetworkService()
    service.mockData = """
          {
            "success": true
          }
          """.data(using: .utf8)!

    sut = HomeRemoteDataSourceImpl(service: service)

    //when
    let model = try await sut.fetchSkills(params: ["": ""])

    //then
    let success = try XCTUnwrap(model.success)
    XCTAssertTrue(success)
  }

  func test_fetchCategories_shouldReturnFailure() async throws {
    //given
    let service = MockNetworkService()
    service.mockError = NetworkErrorMessage(code: -5, description: "Unknown Error")

    sut = HomeRemoteDataSourceImpl(service: service)
    var nError: NetworkErrorMessage!

    //when
    do {
      _ = try await sut.fetchSkills(params: ["": ""])
      XCTFail("should failure")
    } catch {
      nError = error as? NetworkErrorMessage
    }

    //then
    XCTAssertNotNil(nError)
  }

  func test_fetchCategoryArticle_shouldReturnSuccess() async throws {
    //given
    let service = MockNetworkService()
    service.mockData = """
          {
            "success": true
          }
          """.data(using: .utf8)!

    sut = HomeRemoteDataSourceImpl(service: service)

    //when
    let model = try await sut.fetchCategoryArticle()

    //then
    let success = try XCTUnwrap(model.success)
    XCTAssertTrue(success)
  }

  func test_fetchCategoryArticle_shouldReturnFailure() async throws {
    //given
    let service = MockNetworkService()
    sut = HomeRemoteDataSourceImpl(service: service)
    service.mockError = NetworkErrorMessage(code: -1, description: "should error")
    var nError: NetworkErrorMessage!

    //when
    do {
      _ = try await sut.fetchCategoryArticle()
      XCTFail("expected error to be thrown")
    } catch {
      nError = error as? NetworkErrorMessage
    }

    //then
    XCTAssertEqual(nError.description, "should error")
  }

  func test_fetchArticles_shouldReturnSuccess() async throws {
    //given
    let service = MockNetworkService()
    let params = ArticleParamRequest(name: "290")
    service.mockData = """
          {
            "success": true
          }
          """.data(using: .utf8)!

    sut = HomeRemoteDataSourceImpl(service: service)

    //when
    let model = try await sut.fetchArticles(params: params.toParam())

    //then
    let success = try XCTUnwrap(model.success)
    XCTAssertTrue(success)
  }

  func test_fetchArticles_shouldReturnFailure() async throws {
    //given
    let service = MockNetworkService()
    let params = ArticleParamRequest(name: "290")
    sut = HomeRemoteDataSourceImpl(service: service)
    service.mockError = NetworkErrorMessage(code: -1, description: "should error")
    var nError: NetworkErrorMessage!

    //when
    do {
      _ = try await sut.fetchArticles(params: params.toParam())
      XCTFail("expected error to be thrown")
    } catch {
      nError = error as? NetworkErrorMessage
    }

    //then
    XCTAssertEqual(nError.description, "should error")
  }

  func test_fetchArticles_fromLocalJson_shouldReturnFailure() async throws {
    //given
    var nError: NetworkErrorMessage? = nil
    let service = MockNetworkService()
    do {
      service.mockData = try loadJSONFromFile(filename: "error", inBundle: .module)
    } catch {
      guard let error = error as? NetworkErrorMessage else { return }
      service.mockError = error
    }

    sut = HomeRemoteDataSourceImpl(service: service)

    //when
    do {
      _ = try await sut.fetchArticles(params: [:])
    } catch {
      nError = error as? NetworkErrorMessage
    }

    //then
    XCTAssertEqual(nError?.code, -3)
  }

}

struct MockHomeRemoteDataSource: HomeRemoteDataSourceLogic,
                                 SKTMRemoteDataSourceLogic,
                                 OngoingUserCaseRemoteDataSourceLogic {

  var mockModel: AdvocateGetResp?
  var mockError: NetworkErrorMessage?
  var params: AdvocateParamRequest?

  let service: NetworkServiceLogic

  init() {
    self.service = MockNetworkService()
  }

  init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  func fetchPromotionBanner() async throws -> BannerResponseModel {
    return .init()
  }

  func fetchOnlineAdvocates(params: [String: Any]) async throws -> AdvocateGetResp {

    if let mockModel = mockModel {
      return mockModel
    }

    if let mockError = mockError {
      throw mockError
    }

    throw URLError(.badServerResponse)
  }

  func fetchSkills(
    params: [String : Any]?
  ) async throws -> SkillResponseModel {

    guard let mockError = mockError else {
      return SkillResponseModel(
        success: true,
        data: [],
        message: "success"
      )
    }

    throw mockError

  }

  func fetchTopAdvocates() async throws -> HomeFlow.TopLawyerAgencyModel {
    fatalError()
  }

  public func fetchOnlineAdvocatesCombine(
    with url: String,
    params: [String: Any]
  ) -> AnyPublisher<AdvocateGetResp, NetworkErrorMessage> {

    Future<AdvocateGetResp, NetworkErrorMessage> { completion in
      if let mockModel = mockModel {
        completion(.success(mockModel))
      }

      if let mockError = mockError {
        completion(.failure(mockError))
      }

    }.eraseToAnyPublisher()

  }

  func fetchCategories() -> AnyPublisher<String, NetworkErrorMessage> {
    fatalError()
  }

  func fetchCategoryArticle() async throws -> CategoryArticleResponseModel {
    fatalError()
  }

  func fetchArticles(params: [String : Any]) async throws -> ArticleResponseModel {
    fatalError()
  }

  func fetchSkills(params: [String : Any]?) async throws -> AprodhitKit.AdvocateSkillGetResp {
    fatalError()
  }

  func fetchNewestArticle() async throws -> [HomeFlow.NewestArticleResponseModel] {
    fatalError()
  }

  func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> AprodhitKit.UserCasesGetResp {
    fatalError()
  }

  func fetchPaymentStatus(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> HomeFlow.PaymentStatusModel {
    fatalError()
  }

  func fetchSKTM(headers: [String : String]) async throws -> AprodhitKit.ClientGetSKTM {
    fatalError()
  }

}
