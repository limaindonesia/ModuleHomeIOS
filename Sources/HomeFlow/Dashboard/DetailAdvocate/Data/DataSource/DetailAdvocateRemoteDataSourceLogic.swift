//
//  DetailAdvocateRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import Foundation
import GnDKit
import AprodhitKit

public protocol DetailAdvocateRemoteDataSourceLogic {
  
  func getDetailAdvocate(
    headers: [String: String],
    parameters: [String: Any]
  ) async throws -> AdvocateGetRespSingle
  
  func getLawyerReview(
    headers: [String: String],
    parameters: [String: Any]
  ) async throws -> LawyerReviewListGetResp
  
  func getLawyerRating(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> LawyerRatingsGeneralGetResp
}

public class DetailAdvocateRemoteDataSourceImpl: DetailAdvocateRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func getDetailAdvocate(
    headers: [String: String],
    parameters: [String: Any]
  ) async throws -> AdvocateGetRespSingle {
    
    guard let slug = parameters["slug"] as? String else {
      throw NetworkErrorMessage(
        code: -6,
        description: "Terjadi kesalahan"
      )
    }
    
    do {
      let data = try await service.request(
        with: Endpoint.DETAIL_LAWYER.appending(slug),
        withMethod: .get,
        withHeaders: headers,
        withParameter: nil,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(AdvocateGetRespSingle.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  public func getLawyerReview(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> LawyerReviewListGetResp {
    
    guard let lawyerID = parameters["lawyer_id"] as? Int else {
      throw NetworkErrorMessage(
        code: -6,
        description: "Terjadi kesalahan"
      )
    }
    
    let params = [
      "limit" : parameters["limit"] ?? 0,
      "page" : parameters["page"] ?? 0
    ]
    
    do {
      let data = try await service.request(
        with: Endpoint.LAWYERS.appending("\(lawyerID)/review-list"),
        withMethod: .get,
        withHeaders: headers,
        withParameter: params,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(LawyerReviewListGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  public func getLawyerRating(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> LawyerRatingsGeneralGetResp {
    
    guard let lawyerID = parameters["lawyer_id"] as? Int else {
      throw NetworkErrorMessage(
        code: -6,
        description: "Terjadi kesalahan"
      )
    }

    do {
      let data = try await service.request(
        with: Endpoint.LAWYERS.appending("\(lawyerID)/ratings"),
        withMethod: .get,
        withHeaders: headers,
        withParameter: nil,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(LawyerRatingsGeneralGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
}
