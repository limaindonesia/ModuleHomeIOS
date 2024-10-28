//
//  PaymentRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

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

}

public struct PaymentRemoteDataSource: PaymentRemoteDataSourceLogic {

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

}
