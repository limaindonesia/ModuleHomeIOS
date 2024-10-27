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
  ) async throws -> OrderNumberEntity {
    
    do {
      let response = try await remote.requestOrderByNumber(
        headers.toHeaders(),
        parameters.toParam()
      )
      let entity = response.data.map(OrderNumberEntity.map(from:)) ?? .init()
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


}
