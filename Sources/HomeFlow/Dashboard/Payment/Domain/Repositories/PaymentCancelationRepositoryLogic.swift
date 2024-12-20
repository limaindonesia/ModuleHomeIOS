//
//  PaymentCancelationRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

import Foundation
import AprodhitKit

public protocol PaymentCancelationRepositoryLogic {
  
  func requestReasons(headers: HeaderRequest) async throws -> [ReasonEntity]
  
  func requestCancelReason(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool
  
  func requestPaymentCancel(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool
  
  func requestDismissRefund(
    headers: HeaderRequest,
    parameters: DismissRefundRequest
  ) async throws -> Bool
  
}
