//
//  PaymentCancelationRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

import Foundation
import GnDKit
import AprodhitKit

public protocol PaymentCancelationRemoteDataSourceLogic {
  
  func requestCancelationReason(headers: [String : String]) async throws -> ReasonResponseModel
  
  func requestCancelReason(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool
  
  func requestPaymentCancel(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool
  
}

public class PaymentCancelationRemoteDataSource: PaymentCancelationRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func requestCancelationReason(headers: [String : String]) async throws -> ReasonResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.CANCELLATION_REASON,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let model = try JSONDecoder().decode(ReasonResponseModel.self, from: data)
      return model
      
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
  
  public func requestCancelReason(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    do {
      let data = try await service.request(
        with: Endpoint.CANCELLATION_REASON,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let success = json["success"] as? Bool {
          return success
        }
      }
     
      return false
      
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
  
  public func requestPaymentCancel(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    do {
      let data = try await service.request(
        with: Endpoint.PAYMENT_CANCEL,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let success = json["success"] as? Bool {
          return success
        }
      }
     
      return false
      
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
