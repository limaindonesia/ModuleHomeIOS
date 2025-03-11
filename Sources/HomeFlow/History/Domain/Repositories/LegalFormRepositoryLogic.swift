//
//  LegalFormRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//

import Foundation
import GnDKit
import AprodhitKit

public protocol LegalFormRepositoryLogic {
  
  func fetchLegalFormDocuments(
    headers: HeaderRequest,
    parameters: UserCasesParamRequest
  ) async throws -> [LegalFormEntity]
  
  func fetchDocumentByID(
    headers: HeaderRequest,
    id: String
  ) async throws -> DocumentByIDEntity
  
}
