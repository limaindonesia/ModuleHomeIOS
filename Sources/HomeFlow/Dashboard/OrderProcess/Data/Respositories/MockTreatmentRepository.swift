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
    return []
  }

}
