//
//  FakePaymentRepository.swift
//
//
//  Created by Ilham Prabawa on 27/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct FakePaymentRepository: PaymentRepositoryLogic {
  
  private let remote: PaymentRemoteDataSourceLogic
  
  public init(remote: PaymentRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderEntity {
    
    do {
      let response = try await remote.requestOrderByNumber(
        headers.toHeaders(),
        parameters.toParam()
      )
      let entity = response.data.map(OrderEntity.map(from:)) ?? .init()
      return entity
      
    } catch {
      guard let error = error as? NetworkErrorMessage else {
        throw ErrorMessage(
          id: -1,
          title: "Failed",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
    }
    
  }
  
  public func requestUseVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> VoucherEntity {
    return VoucherEntity(
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
    
    return PaymentEntity(
      urlString: "",
      roomKey: ""
    )
  }
  
  public func requestRemoveVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> Bool {
    fatalError()
  }
  
  public func requestRejectionPayment(
    headers: HeaderRequest,
    parameters: PaymentRejectionRequest
  ) async throws -> Bool {
    fatalError()
  }
  
  public func requestReasons() async throws -> [ReasonEntity] {
    return []
  }
  
  public func requestCancelReason(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentCancel(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentMethod(headers: HeaderRequest) async throws -> [PaymentMethodEntity] {
    return .init()
  }
  
  public func requestEligibleVoucher(
    headers: HeaderRequest,
    parameters: EligibleVoucherParamRequests
  ) async throws -> [EligibleVoucherEntity] {
    return [
      .init(
        name: "Bronze Pertamina",
        code: "BRONZE12",
        tnc: "",
        expiredDate: Date()
      ),
      .init(
        name: "Bronze Shell",
        code: "BRONZE99",
        tnc: "",
        expiredDate: Date()
      )
    ]
  }
}
