//
//  KemenPPPARepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import GnDKit
import AprodhitKit

public class KemenPPPARepositoryImpl: KemenPPPARepositoryLogic {
  
  private let remote: KemenPPPARemoteDataSourceLogic
  
  public init(remote: KemenPPPARemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func fetchCategories(headers: HeaderRequest) async throws -> [ViolenceCategoryEntity] {
    do {
      let response = try await remote.fetchCategories(headers: headers.toHeaders())
      return response.data?.map{ data in
        ViolenceCategoryEntity(
          id: data.id ?? 0,
          title: data.name ?? "",
          description: data.description ?? ""
        )
      } ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
  public func fetchReasonsKemenPPPA(headers: HeaderRequest) async throws -> [ReasonEntity] {
    do {
      let response = try await remote.fetchReasonsKemenPPPA(headers: headers.toHeaders())
      return response.data?.map(ReasonEntity.map(from:)) ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
  public func fetchPrivacyPolicyKemenPPPA(headers: HeaderRequest) async throws -> String {
    do {
      let response = try await remote.fetchPrivacyPolicyKemenPPPA(headers: headers.toHeaders())
      return response.wrappedInHTML
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
  public func requestCreateConsultationKemenPPPA(
    headers: HeaderRequest,
    params: Paramable
  ) async throws -> String {
    do {
      let response = try await remote.requestCreateConsultationKemenPPPA(
        headers: headers.toHeaders(),
        params: params.toParam()
      )
      return response
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
}
