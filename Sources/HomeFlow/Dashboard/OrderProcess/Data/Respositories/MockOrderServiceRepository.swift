//
//  MockTreatmentRepository.swift
//
//
//  Created by Muhammad Yusuf on 24/10/24.
//

import Foundation
import AprodhitKit

public struct MockOrderServiceRepository: OrderServiceRepositoryLogic {
  
  public init() {}
  
  public func fetchOrderService(
    _ headers: HeaderRequest,
    _ parameters: OrderServiceParamRequest
  )  async throws -> [OrderServiceEntity] {
    return [
      .init(
        name: "Probono (Chat Saja)",
        type: "PROBONO",
        status: "ACTIVE",
        duration: 20,
        price: 0,
        originalPrice: 0,
        iconURL: "https://storage....."
      ),
      .init(
        name: "Chat Saja",
        type: "REGULAR",
        status: "ACTIVE",
        duration: 40,
        price: 40000,
        originalPrice: 60000,
        iconURL: "https://storage....."
      ),
      .init(
        name: "Chat + Voice + Video Call",
        type: "REGULAR_AUDIO_VIDEO",
        status: "ACTIVE",
        duration: 60,
        price: 50000,
        originalPrice: 70000,
        iconURL: "https://storage....."
      )
    ]
  }
  
}
