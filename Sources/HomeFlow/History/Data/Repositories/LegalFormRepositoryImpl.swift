//
//  LegalFormRepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//

import Foundation
import GnDKit
import AprodhitKit

public class LegalFormRepositoryImpl: LegalFormRepositoryLogic {
  
  private let remote: LegalDocumentRemoteDataSourceLogic
  
  public init(remote: LegalDocumentRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func fetchLegalFormDocuments(
    headers: HeaderRequest,
    parameters: UserCasesParamRequest
  ) async throws -> [LegalFormEntity] {
    do {
      let response = try await remote.requestHistoryLegalDocuments(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      let entities = response.data?.data?.map(LegalFormEntity.map(from:))
      return entities ?? []
      
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
        title: "Gagal",
        message: error.description
      )
    }
  }
  
  public func fetchDocumentByID(
    headers: HeaderRequest,
    id: String
  ) async throws -> DocumentByIDEntity {
    do {
      let response = try await remote.fetchDocumentByID(
        headers: headers.toHeaders(),
        id: id
      )
      
      let entity = response.data.map(DocumentByIDEntity.map(from:))
      return entity ?? .init()
      
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
        title: "Gagal",
        message: error.description
      )
    }
  }
}
