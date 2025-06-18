//
//  KemenPPPARemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

public protocol KemenPPPARemoteDataSourceLogic {
  func fetchCategories() async throws -> [ViolenceCategoryEntity]
  func fetchReasonsKemenPPPA() async throws -> KemenPPPAReasonResponse
  func fetchPrivacyPolicyKemenPPPA() async throws -> String
}
