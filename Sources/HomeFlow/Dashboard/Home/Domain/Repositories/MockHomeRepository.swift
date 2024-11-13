//
//  MockHomeRepository.swift
//
//
//  Created by Ilham Prabawa on 10/08/24.
//

import Foundation
import AprodhitKit

public struct MockHomeRepository: HomeRepositoryLogic,
                                  SKTMRepositoryLogic,
                                  OngoingRepositoryLogic {
  
  public func fetchSkills(params: CategoryParamRequest?) async throws -> [AdvocateSkills] {
    try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    var entities: [AdvocateSkills] = []
    var i = 0
    while i < 7 {
      entities.append(.init())
      i += 1
    }
    
    return entities
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {
    
    fatalError()
  }
  
  public func fetchPaymentStatus(
    headers: [String : String],
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity {
    
    fatalError()
  }
  
  public init() {}
  
  public func fetchOnlineAdvocates(params: AdvocateParamRequest) async throws -> [Advocate] {
    return [
      Advocate(),
      Advocate(),
      Advocate()
    ]
  }
  
  public func fetchOnlineAdvocates(params: AdvocateParamRequest) async throws -> [AdvocateEntity] {
    try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    return [
      AdvocateEntity(),
      AdvocateEntity(),
      AdvocateEntity()
    ]
  }
  
  public func fetchTopAdvocates() async throws -> (
    TopDataEntity,
    [TopAdvocateEntity],
    [TopAgencyEntity]
  ) {
    var advocateEntities: [TopAdvocateEntity] = []
    var agencyEntities: [TopAgencyEntity] = []
    
    for i in 0 ..< 10 {
      advocateEntities.append(
        TopAdvocateEntity(
          position: i+1,
          lawyerID: i+1,
          name: "",
          image: "",
          agency: "",
          yearExp: 7
        )
      )
      
      agencyEntities.append(
        TopAgencyEntity()
      )
    }
    
    let dataEntity = TopDataEntity(month: 0, year: 0)
    
    return (dataEntity, advocateEntities, agencyEntities)
  }
  
  public func fetchCategoryArticle() async throws -> [CategoryArticleEntity] {
    var entities: [CategoryArticleEntity] = []
    for i in 0 ..< 20 {
      entities.append(CategoryArticleEntity(id: i+1))
    }
    
    return entities
  }
  
  public func fetchArticles(params: ArticleParamRequest) async throws -> [ArticleEntity] {
    var entities: [ArticleEntity] = []
    for _ in 0 ..< 20 {
      entities.append(
        ArticleEntity()
      )
    }
    
    return entities
  }
  
  public func fetchNewestArticle() async throws -> [ArticleEntity] {
    fatalError()
  }
  
  public func fetchSKTM(headers: [String : String]) async throws -> ClientGetSKTM {
    fatalError()
  }
  
  public func fetchPromotionBanner() async throws -> BannerPromotionEntity {
    return .init()
  }
  
}
