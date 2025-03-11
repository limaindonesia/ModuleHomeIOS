//
//  HistoryConsultationRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/02/25.
//
import Foundation
import GnDKit
import AprodhitKit

public protocol ConsultationHistoryRepositoryLogic {
  
  func getConsultations(
    headers: HeaderRequest,
    parameters: UserCasesParamRequest
  ) async throws -> ([ConsultationHistoryEntity], [UserCases])
  
}
