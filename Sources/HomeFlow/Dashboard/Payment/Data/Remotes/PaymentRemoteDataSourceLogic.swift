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
  
  func requestRejectionPayment(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool
  
  
  func requestPaymentMethods(headers: [String : String]) async throws -> PaymentMethodResponseModel
  
}

public struct PaymentRemoteDataSource: PaymentRemoteDataSourceLogic,
                                       OngoingUserCaseRemoteDataSourceLogic,
                                       PaymentCancelationRemoteDataSourceLogic {
  
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
  
  public func requestRejectionPayment(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    do {
      let data = try await service.request(
        with: "",
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let succeeded = try JSONDecoder().decode(Bool.self, from: data)
      return succeeded
      
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
  
  public func requestCancelationReason(headers: [String : String]) async throws -> ReasonResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.CANCELLATION_REASON,
        withMethod: .get,
        withHeaders: [:],
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
      let succeeded = try JSONDecoder().decode(Bool.self, from: data)
      return succeeded
      
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
      let succeeded = try JSONDecoder().decode(Bool.self, from: data)
      return succeeded
      
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
  
  public func requestPaymentMethods(headers: [String : String]) async throws -> PaymentMethodResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.PAYMENT_METHOD,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let response = try JSONDecoder().decode(PaymentMethodResponseModel.self, from: data)
      return response
      
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
