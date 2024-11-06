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
  ) async throws -> OrderEntity {

    return OrderEntity(
      consultationID: -8,
      lawyerFee: .init(),
      adminFee: .init(),
      discountFee: .init(),
      voucher: nil,
      total: "Rp60.000",
      totalAdjustment: 150000,
      expiredAt: 1729926810
    )

  }

  public func requestUseVoucher(
    headers: AprodhitKit.HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> VoucherEntity {

    VoucherEntity(
      success: false,
      code: "",
      amount: "",
      tnc: "",
      descriptions: "",
      duration: 0
    )

  }

  public func requestCreatePayment(
    headers: HeaderRequest,
    parameters: PaymentParamRequest
  ) async throws -> PaymentEntity {

    PaymentEntity(urlString: "", roomKey: "")
  }
  
  public func requestRemoveVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> Bool {
    fatalError()
  }

}
