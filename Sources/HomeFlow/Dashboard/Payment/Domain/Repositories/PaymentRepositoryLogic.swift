//
//  PaymentRepositoryLogic.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public protocol PaymentRepositoryLogic {

  func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderEntity

  func requestUseVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> VoucherEntity

  func requestCreatePayment(
    headers: HeaderRequest,
    parameters: PaymentParamRequest
  ) async throws -> PaymentEntity
  
  func requestRemoveVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> Bool

  func requestRejectionPayment(
    headers: HeaderRequest,
    parameters: PaymentRejectionRequest
  ) async throws -> Bool
  
}
