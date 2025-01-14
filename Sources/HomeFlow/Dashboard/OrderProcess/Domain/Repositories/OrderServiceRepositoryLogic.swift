//
//  OrderProcessRepositoryLogic.swift
//
//
//  Created by Muhammad Yusuf on 25/10/24.
//

import Foundation
import AprodhitKit

public protocol OrderServiceRepositoryLogic {
  func fetchOrderService(
  _ headers: HeaderRequest,
  _ parameters: OrderServiceParamRequest) async throws -> [OrderServiceEntity]
}
