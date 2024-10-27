//
//  MockOrderProcessRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public struct MockOrderProcessRepository: OrderProcessRepositoryLogic {

  public init() {}
  
  public func requestBookingOrder(
    _ headers: HeaderRequest,
    _ parameters: BookingOrderParamRequest
  ) async throws -> BookingOrderEntity {
    return BookingOrderEntity(orderNumber: "PC-1837394")
  }

}
