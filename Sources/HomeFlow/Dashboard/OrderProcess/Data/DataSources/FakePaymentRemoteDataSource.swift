//
//  FakePaymentRemoteDataSource.swift
//
//
//  Created by Ilham Prabawa on 26/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct FakePaymentRemoteDataSource: PaymentRemoteDataSourceLogic {
  
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
    
    fatalError()
    
  }
  
  public func requestRemoveVoucher(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> Bool {
    
    return true
    
  }
  
}
