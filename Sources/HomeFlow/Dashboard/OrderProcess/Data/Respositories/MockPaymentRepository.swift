//
//  MockPaymentRepository.swift
//  
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public struct MockPaymentRepository: PaymentRepositoryLogic {

  public init() {}

  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderResponseModel {
    fatalError()
  }

}
