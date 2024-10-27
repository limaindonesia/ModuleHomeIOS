//
//  MockPaymentRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct MockPaymentRepository: PaymentRepositoryLogic {

  public init() {}

  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderNumberEntity {

    return OrderNumberEntity(
      lawyerFee: .init(),
      adminFee: .init(),
      discountFee: .init(),
      total: "Rp60.000",
      expiredAt: 1729926810
    )

  }

}
