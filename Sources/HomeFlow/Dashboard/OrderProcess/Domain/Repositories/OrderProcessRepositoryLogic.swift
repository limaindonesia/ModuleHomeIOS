//
//  OrderProcessRepositoryLogic.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public protocol OrderProcessRepositoryLogic {

  func requestBookingOrder(
    _ headers: HeaderRequest,
    _ parameters: BookingOrderParamRequest
  ) async throws -> BookingOrderEntity

}
