//
//  PaymentRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PaymentRemoteDataSourceLogic {
  
  func requestOrderByNumber(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> OrderResponseModel
  
  func requestCreatePayment(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> PaymentResponseModel
  
  func requestUseVoucher(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> VoucherResponseModel
  
  func requestRemoveVoucher(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool
  
}

public struct PaymentRemoteDataSource: PaymentRemoteDataSourceLogic,
                                       OngoingUserCaseRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func requestOrderByNumber(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> OrderResponseModel {
    
    do {
      let data = try await service.request(
        with: Endpoint.ORDER_BY_NUMBER,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(OrderResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  public func requestCreatePayment(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> PaymentResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.PAYMENT,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )
      let json = try JSONDecoder().decode(PaymentResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func requestUseVoucher(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> VoucherResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.USE_VOUCHER,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )
      let json = try JSONDecoder().decode(VoucherResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func requestRemoveVoucher(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    var succeeded: Bool = false
    
    do {
      let data = try await service.request(
        with: Endpoint.REMOVE_VOUCHER,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String: Any] {
        if let success = json["succes"] as? Bool {
          succeeded = success
        }
      }
    } catch {
      succeeded = false
      throw error
    }
    
    return succeeded
    
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
  
}
