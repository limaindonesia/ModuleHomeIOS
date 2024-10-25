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
  ) async throws -> OrderNumberResponseModel

}

public struct PaymentRemoteDataSource: PaymentRemoteDataSourceLogic {

  private let service: NetworkServiceLogic

  public init(service: NetworkServiceLogic) {
    self.service = service
  }

  public func requestOrderByNumber(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> OrderNumberResponseModel {

    do {
      let data = try await service.request(
        with: Endpoint.ORDER_BY_NUMBER,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(OrderNumberResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }

  }

}
