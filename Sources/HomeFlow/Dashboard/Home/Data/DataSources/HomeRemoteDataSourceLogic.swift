//
//  HomeRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public protocol HomeRemoteDataSourceLogic {
  
  func fetchOnlineAdvocates(
    params: [String: Any]
  ) async throws -> AdvocateGetResp
  
  func fetchSkills(
    params: [String: Any]?
  ) async throws -> AdvocateSkillGetResp
  
  func fetchTopAdvocates() async throws -> TopLawyerAgencyModel
  
  func fetchArticles(params: [String: Any]) async throws -> ArticleResponseModel
  
  func fetchCategoryArticle() async throws -> CategoryArticleResponseModel
  
  func fetchNewestArticle() async throws -> [NewestArticleResponseModel]
  
  func fetchPaymentStatus(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PaymentStatusModel
  
  func fetchPromotionBanner() async throws -> BannerResponseModel
  
}

public struct HomeRemoteDataSourceImpl: HomeRemoteDataSourceLogic,
                                        SKTMRemoteDataSourceLogic,
                                        OngoingUserCaseRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchOnlineAdvocates(
    params: [String: Any]
  ) async throws -> AdvocateGetResp {
    
    let data = try await service.request(
      with: Endpoint.LAWYER_LIST,
      withMethod: .post,
      withHeaders: nil,
      withParameter: params,
      withEncoding: .json
    )
    
    do {
      let json = try JSONDecoder().decode(AdvocateGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  public func fetchSkills(
    params: [String: Any]?
  ) async throws -> AdvocateSkillGetResp {
    
    let data = try await service.request(
      with: Endpoint.SKILLS,
      withMethod: .get,
      withHeaders: nil,
      withParameter: params,
      withEncoding: .url
    )
    
    do {
      let json = try JSONDecoder().decode(AdvocateSkillGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchTopAdvocates() async throws -> TopLawyerAgencyModel {
    let data = try await service.request(
      with: Endpoint.TOP_ADVOCATE,
      withMethod: .get,
      withHeaders: nil,
      withParameter: nil,
      withEncoding: .url
    )
    
    do {
      let response = try JSONDecoder().decode(TopLawyerAgencyModel.self, from: data)
      return response
    } catch {
      throw error
    }
  }
  
  public func fetchArticles(
    params: [String: Any]
  ) async throws -> ArticleResponseModel {
    
    let data = try await service.request(
      with: Endpoint.ARTICLE,
      withMethod: .get,
      withHeaders: nil,
      withParameter: params,
      withEncoding: .url
    )
    
    do {
      let json = try JSONDecoder().decode(ArticleResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchCategoryArticle() async throws -> CategoryArticleResponseModel {
    let data = try await service.request(
      with: Endpoint.ARTICLE_CATEGORY,
      withMethod: .get,
      withHeaders: nil,
      withParameter: nil,
      withEncoding: .url
    )
    
    do {
      let json = try JSONDecoder().decode(CategoryArticleResponseModel.self, from: data)
      return json
    } catch {
      throw error as! NetworkErrorMessage
    }
  }
  
  public func fetchNewestArticle() async throws -> [NewestArticleResponseModel] {
    do {
      let data = try await service.request(
        with: Endpoint.NEWEST_ARTICLE,
        withMethod: .get,
        withHeaders: [:],
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode([NewestArticleResponseModel].self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchSKTM(headers: [String : String]) async throws -> ClientGetSKTM {
    do {
      let data = try await service.request(
        with: Endpoint.SKTM,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(ClientGetSKTM.self, from: data)
      return json
    } catch {
      guard let error = error as? NetworkErrorMessage else {
        throw NetworkErrorMessage(
          code: -1,
          description: "Unknown Error"
        )
        
      }
      
      throw error
    }
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> UserCasesGetResp {
    do {
      let data = try await service.request(
        with: Endpoint.USER_CASES,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(UserCasesGetResp.self, from: data)
      return json
    } catch {
      guard let error = error as? NetworkErrorMessage else {
        throw NetworkErrorMessage(
          code: -1,
          description: "Unknown Error"
        )
        
      }
      
      throw error
    }
  }
  
  public func fetchPaymentStatus(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PaymentStatusModel {
    
    do {
      let data = try await service.request(
        with: Endpoint.CHECK_STATUS,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(PaymentStatusModel.self, from: data)
      return json
    } catch {
      guard let error = error as? NetworkErrorMessage else {
        throw NetworkErrorMessage(
          code: -1,
          description: "Unknown Error"
        )
        
      }
      
      throw error
    }
    
  }
  
  public func fetchPromotionBanner() async throws -> BannerResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.BANNER,
        withMethod: .get,
        withHeaders: [:],
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(BannerResponseModel.self, from: data)
      return json
    } catch {
      guard let error = error as? NetworkErrorMessage else {
        throw NetworkErrorMessage(
          code: -1,
          description: "Unknown Error"
        )
        
      }
      
      throw error
      
    }
  }
  
}
