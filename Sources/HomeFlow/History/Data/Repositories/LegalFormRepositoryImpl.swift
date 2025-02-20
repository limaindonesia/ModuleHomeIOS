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
  
  public func fetchLegalFormDocuments() async throws -> [LegalFormDocumentEntity] {
    do {
      return []
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
