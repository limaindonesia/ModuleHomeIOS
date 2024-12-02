//
//  MockPaymentCheckRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 29/11/24.
//
import Foundation
import AprodhitKit
import GnDKit

public struct MockPaymentCheckRepository: PaymentCheckRepositoryLogic {
  
  public init() {}
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {
    return [.init()]
  }
  
  public func requestPaymentStatus(
    headers: HeaderRequest,
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity {
    return .init(
      paymentURL: "http://google.com",
      roomKey: "934ehuh857ithurhir",
      status: "PENDING"
    )
  }

}
