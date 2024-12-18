//
//  ConsultationsRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 16/12/24.
//

import Foundation
import AprodhitKit

public protocol ConsultationsRepositoryLogic {
  
  func requestConsultationById(
    headers: HeaderRequest,
    _ consultationID: Int
  ) async throws -> UserCaseEntity
  
}
