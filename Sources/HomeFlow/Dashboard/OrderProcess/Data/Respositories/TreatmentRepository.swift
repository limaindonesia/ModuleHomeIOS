//
//  TreatmentRepository.swift
//  
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct TreatmentRepository: TreatmentRepositoryLogic {

  private let remote: TreatmentRemoteDataSourceLogic

  public init(remote: TreatmentRemoteDataSourceLogic) {
    self.remote = remote
  }

  public func fetchTreatments() async throws -> [TreatmentEntity] {
    do {
      let model = try await remote.fetchTreatments()
      return model.data.map(TreatmentEntity.map(from:))
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
