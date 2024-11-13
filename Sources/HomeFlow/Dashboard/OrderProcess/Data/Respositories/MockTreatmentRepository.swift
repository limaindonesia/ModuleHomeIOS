//
//  MockTreatmentRepository.swift
//  
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation

public struct MockTreatmentRepository: TreatmentRepositoryLogic {

  public init() {}

  public func fetchTreatments() async throws -> [TreatmentEntity] {
    return [
      .init(
        duration: 30,
        type: "PROBONO"
      ),
      .init(
        duration: 45,
        type: "REGULAR"
      )
    ]
  }

}
