//
//  OrderProcessRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct OrderProcessRepository: OrderProcessRepositoryLogic {

  private let remote: OrderProcessRemoteDataSourceLogic

  public init(remote: OrderProcessRemoteDataSourceLogic) {
    self.remote = remote
  }

  public func requestBookingOrder(
    _ headers: HeaderRequest,
    _ parameters: BookingOrderParamRequest
  ) async throws -> BookingOrderEntity {

    do {
      let orderNumber = try await remote.requestBookingOrder(
        headers.toHeaders(),
        parameters.toParam()
      )

     return BookingOrderEntity(orderNumber: orderNumber)

    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
        )
      }

      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )

    }

  }

}
