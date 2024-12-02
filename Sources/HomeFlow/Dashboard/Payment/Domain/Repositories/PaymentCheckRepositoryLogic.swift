//
//  PaymentCheckRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PaymentCheckRepositoryLogic: OngoingRepositoryLogic {
  
  func requestPaymentStatus(
    headers: HeaderRequest,
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity

}
