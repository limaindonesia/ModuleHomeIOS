//
//  KemenPPPARemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import Foundation
import AprodhitKit

public protocol KemenPPPARemoteDataSourceLogic {
  func fetchCategories(headers: [String : String]) async throws -> KemenPPPASkillResponse
  func fetchReasonsKemenPPPA(headers: [String : String]) async throws -> ReasonResponseModel
  func fetchPrivacyPolicyKemenPPPA(headers: [String : String]) async throws -> String
  func requestCreateConsultationKemenPPPA(
    headers: [String : String],
    params: [String : Any]
  ) async throws -> String
}

public class KemenPPPARemoteDataSourceImpl: KemenPPPARemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchCategories(headers: [String : String]) async throws -> KemenPPPASkillResponse {
    do {
      let data = try await service.request(
        with: Endpoint.SKILLS,
        withMethod: .get,
        withHeaders: headers,
        withParameter: ["type" : "kemenpppa"],
        withEncoding: .url
      )
      
      let json = try JSONDecoder().decode(KemenPPPASkillResponse.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchReasonsKemenPPPA(headers: [String : String]) async throws -> ReasonResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.REASON_KEMENPPPA,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(ReasonResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchPrivacyPolicyKemenPPPA(headers: [String : String]) async throws -> String {
    var result: String = ""
    
    do {
      let data = try await service.request(
        with: Endpoint.PRIVACY_POLICY_KEMENPPPA,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let data = json["data"] as? [String : Any] {
          if let content = data["content"] as? String {
            result = content
          }
        }
      }
    } catch {
      throw error
    }
    
    return result
  }
  
  public func requestCreateConsultationKemenPPPA(
    headers: [String : String],
    params: [String : Any]
  ) async throws -> String {
    
    var roomKey: String = ""
    
    do {
      let data = try await service.request(
        with: Endpoint.CREATE_CONSULTATION_KEMENPPPA,
        withMethod: .post,
        withHeaders: headers,
        withParameter: params,
        withEncoding: .json
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let data = json["data"] as? [String : Any] {
          if let content = data["room_key"] as? String {
            roomKey = content
          }
        }
      }
    } catch {
      throw error
    }
    
    return roomKey
    
  }
  
}
