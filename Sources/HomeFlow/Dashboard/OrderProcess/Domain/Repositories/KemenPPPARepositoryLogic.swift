//
//  KemenPPPARepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import AprodhitKit

public protocol KemenPPPARepositoryLogic {
  func fetchCategories(headers: HeaderRequest) async throws -> [ViolenceCategoryEntity]
  func fetchReasonsKemenPPPA(headers: HeaderRequest) async throws -> [ReasonEntity]
  func fetchPrivacyPolicyKemenPPPA(headers: HeaderRequest) async throws -> String
  func requestCreateConsultationKemenPPPA(headers: HeaderRequest, params: Paramable) async throws -> String
}
