//
//  PaymentRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct PaymentRepository: PaymentRepositoryLogic {

  private let remote: PaymentRemoteDataSourceLogic

  public init(remote: PaymentRemoteDataSourceLogic) {
    self.remote = remote
  }

  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderNumberEntity {

    do {
      let json = try await remote.requestOrderByNumber(
        headers.toHeaders(),
        parameters.toParam()
      )

      let entity = json.data.map(OrderNumberEntity.map(from:))!
      return entity
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
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
