//
//  FakePaymentRemoteDataSource.swift
//
//
//  Created by Ilham Prabawa on 26/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct FakePaymentRemoteDataSource: PaymentRemoteDataSourceLogic,
                                           OngoingUserCaseRemoteDataSourceLogic,
                                           PaymentCancelationRemoteDataSourceLogic {
  
  public init() {}
  
  public func requestOrderByNumber(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> OrderResponseModel {
    
    guard let data = try? loadJSONFromFile(
      filename: "order_number_with_voucher",
      inBundle: .module
    )
    else {
      throw ErrorMessage(
        id: -7,
        title: "Failed",
        message: "File Not Found"
      )
    }
    
    var model: OrderResponseModel
    
    do {
      model = try JSONDecoder().decode(OrderResponseModel.self, from: data)
    } catch {
      GLogger(
        .info,
        layer: "Data",
        message: "error \(error)"
      )
      throw ErrorMessage(
        id: -4,
        title: "Failed",
        message: "Parse Error"
      )
    }
    
    return model
  }
  
  public func requestUseVoucher(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> VoucherResponseModel {
    
    guard let data = try? loadJSONFromFile(
      filename: "voucher",
      inBundle: .module
    ) else {
      throw NetworkErrorWithPayload(
        code: -1,
        description: "Failed Response",
        payload: [
          "success" : false,
          "message" : "Maaf, kode voucher tidak dapat digunakan karena kuota telah habis."
        ]
      )
    }
    
    var model: VoucherResponseModel
    
    do {
      model = try JSONDecoder().decode(VoucherResponseModel.self, from: data)
    } catch {
      GLogger(
        .info,
        layer: "Data",
        message: "error \(error)"
      )
      
      throw NetworkErrorWithPayload(
        code: -1,
        description: "Failed Response",
        payload: [
          "success" : false,
          "message" : "Maaf, kode voucher tidak dapat digunakan karena kuota telah habis."
        ]
      )
    }
    
    return model
    
  }
  
  public func requestCreatePayment(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> PaymentResponseModel {
    
    guard let data = try? loadJSONFromFile(
      filename: "payment",
      inBundle: .module
    ) else {
      throw NetworkErrorMessage(
        code: -1,
        description: "Failed Response"
      )
    }
    
    var model: PaymentResponseModel
    
    do {
      model = try JSONDecoder().decode(PaymentResponseModel.self, from: data)
    } catch {
      GLogger(
        .info,
        layer: "Data",
        message: "error \(error)"
      )
      
      throw NetworkErrorWithPayload(
        code: -1,
        description: "Failed Response",
        payload: [
          "success" : false,
          "message" : "Maaf, kode voucher tidak dapat digunakan karena kuota telah habis."
        ]
      )
    }
    
    return model
    
  }
  
  public func requestRemoveVoucher(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    return true
    
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> UserCasesGetResp {
    return .init()
  }
  
  public func requestRejectionPayment(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    return true
  }
  
  public func requestCancelationReason(headers: [String : String]) async throws -> ReasonResponseModel {
    return .init()
  }
  
  public func requestCancelReason(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentCancel(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentMethods(headers: [String : String]) async throws -> PaymentMethodResponseModel {
    guard let data = try? loadJSONFromFile(filename: "payment_method", inBundle: .module)
    else {
      throw URLError(.badURL)
    }
    
    do {
      let model = try JSONDecoder().decode(PaymentMethodResponseModel.self, from: data)
      return model
      
    } catch {
      throw URLError(.badURL)
    }
    
  }
  
}
