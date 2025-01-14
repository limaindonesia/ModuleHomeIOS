//
//  TreatmentRepository.swift
//  
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct OrderServiceRepository: OrderServiceRepositoryLogic {

  private let remote: OrderServiceRemoteDataSourceLogic

  public init(remote: OrderServiceRemoteDataSourceLogic) {
    self.remote = remote
  }

  public func fetchOrderService(
  _ headers: HeaderRequest,
  _ parameters: OrderServiceParamRequest) async throws -> [OrderServiceEntity] {
    do {
      let model = try await remote.fetchOrderService(
        headers.toHeaders(),
        parameters.toParam()
      )
      return model.data.map(OrderServiceEntity.map(from:))
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
