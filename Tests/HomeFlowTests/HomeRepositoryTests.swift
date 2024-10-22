//
//  HomeRepositoryTests.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import Alamofire
import GnDKit
import Combine

final class HomeRepositoryTests: XCTestCase {

  var sut: HomeRepositoryLogic!

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func test_fetchAdvocates_thenMapToEntity() async throws {
    //given
    let mockModel = AdvocateGetResp(
      data: [
        Advocate(),
        Advocate(),
        Advocate()
      ]
    )

    var remoteDataSource = MockHomeRemoteDataSource()
    remoteDataSource.mockModel = mockModel

    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)

    //when
    let entities = try await sut.fetchOnlineAdvocates(params: AdvocateParamRequest(isOnline: true))

    //then
    XCTAssertEqual(entities.count, 3)
  }

  func test_fetchAdvocates_thenThrowError() async throws {
    //given
    let mockError = NetworkErrorMessage(code: -1,
                                        description: "Failed to fetch advocates")

    var remoteDataSource = MockHomeRemoteDataSource()
    remoteDataSource.mockError = mockError

    var errorResult: ErrorMessage?

    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)

    //when
    do {
      _ = try await sut.fetchOnlineAdvocates(params: AdvocateParamRequest(isOnline: true))
    } catch {
      errorResult = error as? ErrorMessage
    }

    //then
    let result = try XCTUnwrap(errorResult)
    XCTAssertEqual(result.message, mockError.description)
  }

  func test_fetchAdvocates_thenThrowAnotherError() async throws {
    //given
    let remoteDataSource = MockHomeRemoteDataSource()
    var errorResult: URLError?

    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)

    //when
    do {
      _ = try await sut.fetchOnlineAdvocates(params: AdvocateParamRequest(isOnline: true))
    } catch {
      errorResult = error as? URLError
    }

    //then
    XCTAssertFalse(errorResult?.code == .badServerResponse)
  }

  func test_fetchAdvocates_andFetchOnlyOnlineAdvocate() async throws {
    //given
    let params = AdvocateParamRequest(isOnline: true)

    var remoteDataSource = MockHomeRemoteDataSource()
    remoteDataSource.params = params

    //when
    //    _ = try await sut.fetchOnlineAdvocates(params: params)

    //then
    XCTAssertEqual(remoteDataSource.params, params)
  }

  func test_fetchCategories_shouldReturnSuccess() async throws {
    //given
    let service = MockNetworkService()
    service.mockData = """
          {
            "success": true,
            "data": [
                      {
                                  "id": 2,
                                  "parent_id": 0,
                                  "icon_url": "https://storage.googleapis.com/perqara-public/skill/icon_1678140580",
                                  "name": "Pidana",
                                  "description": "Pidana",
                                  "types":  [
                                      {
                                          "id": 1,
                                          "name": "pembunuhan",
                                          "description": "Pembunuhan"
                                      },
                                      {
                                          "id": 2,
                                          "name": "penipuan",
                                          "description": "Penipuan"
                                      },
                                       {
                                          "id": 3,
                                          "name": "other",
                                          "description": "Lainnya"
                                      }
                                  ],
                                  "created_at": "2023-03-04T22:58:10.000000Z",
                                  "updated_at": "2023-03-06T15:09:41.000000Z"
                              }

                    ]
          }
          """.data(using: .utf8)!

    let remote = HomeRemoteDataSourceImpl(service: service)

    sut = HomeRepositoryImpl(remoteDataSource: remote)

    //when
    let entities = try await sut.fetchSkills(params: nil)

    //then
    XCTAssertEqual(entities.count, 1)
  }

  func test_fetchCategories_shouldReturnFailure() async throws {
    //given
    let service = MockNetworkService()
    service.mockError = NetworkErrorMessage(code: -5, description: "Unknown Error")

    let remote = HomeRemoteDataSourceImpl(service: service)
    sut = HomeRepositoryImpl(remoteDataSource: remote)

    var nError: ErrorMessage!

    //when
    do {
      _ = try await sut.fetchSkills(params: nil)
      XCTFail("should failure")
    } catch {
      nError = error as? ErrorMessage
    }

    //then
    XCTAssertNotNil(nError)
  }

  func test_fetchAdvocate_usingJsonFromFile() async {
    //given
    let params = AdvocateParamRequest(isOnline: true)
    let remoteDataSource = FakeHomeRemoteDataSource()
    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
    var entities: [AdvocateEntity]?

    //when
    entities = try? await sut.fetchOnlineAdvocates(params: params)

    //then
    XCTAssertNotNil(entities)
  }

  func test_fetchCategoryArticle_usingJsonFromFile_andMapToEntity_withReturnSuccess() async {
    //given
    let remoteDataSource = FakeHomeRemoteDataSource()
    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
    var entities: [CategoryArticleEntity]?

    //when
    entities = try! await sut.fetchCategoryArticle()

    //then
    XCTAssertNotNil(entities)
    let count = try! XCTUnwrap(entities?.count)
    XCTAssertEqual(count, 15)
  }

  func test_fetchArticle_usingJsonFromFile_andMapToEntity_withReturnSuccess() async {
    //given
    let remoteDataSource = FakeHomeRemoteDataSource()
    let params = ArticleParamRequest(id: 6)
    sut = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
    var entities: [ArticleEntity]?

    //when
    entities = try! await sut.fetchArticles(params: params)

    //then
    XCTAssertNotNil(entities)
    let count = try! XCTUnwrap(entities?.count)
    XCTAssertEqual(count, 10)
  }

}
