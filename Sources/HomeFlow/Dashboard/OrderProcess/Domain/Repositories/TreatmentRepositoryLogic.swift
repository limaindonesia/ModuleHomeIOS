//
//  TreatmentRepositoryLogic.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation

public protocol TreatmentRepositoryLogic {
  func fetchTreatments() async throws -> [TreatmentEntity]
}
