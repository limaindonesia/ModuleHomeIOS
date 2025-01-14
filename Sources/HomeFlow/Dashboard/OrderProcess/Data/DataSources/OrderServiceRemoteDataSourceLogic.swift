//
//  TreatmentRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol OrderServiceRemoteDataSourceLogic {

  func fetchOrderService(
    _ headers: [String : String],
    _ parameters: [String : Any]) async throws -> OrderServiceResponseModel

}

public struct OrderServiceRemoteDataSource: OrderServiceRemoteDataSourceLogic {

  private let service: NetworkServiceLogic

  public init(service: NetworkServiceLogic) {
    self.service = service
  }

  public func fetchOrderService(
    _ headers: [String : String],
    _ parameters: [String : Any]) async throws -> OrderServiceResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.ORDER_SERVICE,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(OrderServiceResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }

  }

}
