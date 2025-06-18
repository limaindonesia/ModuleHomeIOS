//
//  KemenPPPARepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

public protocol KemenPPPARepositoryLogic {
  func fetchCategories() async throws -> [ViolenceCategoryEntity]
  func fetchReasonsKemenPPPA() async throws -> [ReasonEntity]
  func fetchPrivacyPolicyKemenPPPA() async throws -> String
}
