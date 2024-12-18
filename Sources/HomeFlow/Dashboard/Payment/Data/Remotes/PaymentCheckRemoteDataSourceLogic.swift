//
//  PaymentCheckRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PaymentCheckRemoteDataSourceLogic {
  
  func requestPaymentStatus(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PaymentStatusModel
  
  func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> UserCasesGetResp
  
  func requestConsultationByID(
    headers: [String : String],
    _ consultationID: Int
  ) async throws -> UserCases
  
}

public class PaymentCheckRemoteDataSource: PaymentCheckRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func requestPaymentStatus(
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
  
  public func requestConsultationByID(
    headers: [String : String],
    _ consultationID: Int
  ) async throws -> UserCases {
    do {
      let data = try await service.request(
        with: Endpoint.CONSULTATION_BY_ID,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(UserCases.self, from: data)
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
