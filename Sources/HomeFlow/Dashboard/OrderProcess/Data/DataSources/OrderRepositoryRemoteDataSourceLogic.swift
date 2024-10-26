//
//  OrderRepositoryRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public protocol OrderProcessRemoteDataSourceLogic {

  func requestBookingOrder(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> String
  
}

public struct OrderProcessRemoteDataSource: OrderProcessRemoteDataSourceLogic {

  private let service: NetworkServiceLogic

  public init(service: NetworkServiceLogic) {
    self.service = service
  }

  public func requestBookingOrder(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> String {

    do {
      let data = try await service.request(
        with: Endpoint.CREATE_CONSULTATION,
        withMethod: .post,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .json
      )

      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let data = json["data"] as? [String: Any] {
          if let orderNumber = data["order_no"] as? String {
            return orderNumber
          }
        }
      }

    } catch {
      throw error
    }

    return ""

  }

}
