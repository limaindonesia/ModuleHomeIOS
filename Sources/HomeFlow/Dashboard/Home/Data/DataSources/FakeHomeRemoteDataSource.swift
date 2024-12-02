//
//  FakeHomeRemoteDataSource.swift
//
//
//  Created by Ilham Prabawa on 30/07/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct FakeHomeRemoteDataSource: HomeRemoteDataSourceLogic,
                                        SKTMRemoteDataSourceLogic,
                                        OngoingUserCaseRemoteDataSourceLogic {
  
  public init() {}
  
  public func fetchOnlineAdvocates(
    params: [String : Any]
  ) async throws -> AdvocateGetResp {
    
    guard let data = try? loadJSONFromFile(filename: "lawyer-list", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    var model: AdvocateGetResp
    do {
      model = try JSONDecoder().decode(AdvocateGetResp.self, from: data)
    } catch {
      throw URLError(.badURL)
    }
    
    return model
  }
  
  public func fetchSkills(
    params: [String : Any]?
  ) async throws -> SkillResponseModel {
    guard let data = try? loadJSONFromFile(filename: "categories", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    var model: SkillResponseModel
    do {
      model = try JSONDecoder().decode(SkillResponseModel.self, from: data)
    } catch {
      throw URLError(.badURL)
    }
    
    return model
  }
  
  public func fetchTopAdvocates() async throws -> TopLawyerAgencyModel {
    guard let data = try? loadJSONFromFile(filename: "top_advocates", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    var model: TopLawyerAgencyModel
    do {
      model = try JSONDecoder().decode(TopLawyerAgencyModel.self, from: data)
    } catch {
      throw URLError(.badURL)
    }
    
    return model
  }
  
  public func fetchCategoryArticle() async throws -> CategoryArticleResponseModel {
    
    var model: CategoryArticleResponseModel
    do {
      let data = try loadJSONFromFile(filename: "article-categories", inBundle: .module)
      model = try JSONDecoder().decode(CategoryArticleResponseModel.self, from: data!)
    } catch {
      throw error as! NetworkErrorMessage
    }
    
    return model
  }
  
  public func fetchArticles(
    params: [String : Any]
  ) async throws -> ArticleResponseModel {
    
    guard let data = try? loadJSONFromFile(filename: "articles", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    var model: ArticleResponseModel
    do {
      model = try JSONDecoder().decode(ArticleResponseModel.self, from: data)
    } catch {
      throw URLError(.badURL)
    }
    
    return model
    
  }
  
  public func fetchNewestArticle() async throws -> [NewestArticleResponseModel] {
    guard let data = try? loadJSONFromFile(filename: "newest_articles", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    var model: [NewestArticleResponseModel]
    do {
      model = try JSONDecoder().decode([NewestArticleResponseModel].self, from: data)
    } catch {
      throw URLError(.badURL)
    }
    
    return model
  }
  
  public func fetchSKTM(headers: [String : String]) async throws -> ClientGetSKTM {
    return .init()
  }
  
  public func fetchSkills(params: [String : Any]?) async throws -> AprodhitKit.AdvocateSkillGetResp {
    return .init(data: [])
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> UserCasesGetResp {
    
    return .init()
  }
  
  public func fetchPaymentStatus(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PaymentStatusModel {
    
    return .init()
  }
  
  public func fetchPromotionBanner() async throws -> BannerResponseModel {
    return .init()
  }
  
  public func requestMe(headers: [String : String]) async throws -> MeResponseModel {
    fatalError()
  }
  
}
