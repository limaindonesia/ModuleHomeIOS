//
//  LegalDocumentRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/03/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol LegalDocumentRemoteDataSourceLogic {
  
  func requestHistoryLegalDocuments(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> LegalDocumentResponseModel
  
  func fetchDocumentByID(
    headers: [String : String],
    id: String
  ) async throws -> DocumentByIDResponseModel
  
}

public class LegalFormRemoteDataSourceImpl: LegalDocumentRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func requestHistoryLegalDocuments(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> LegalDocumentResponseModel {
    
    do {
      let data = try await service.request(
        with: Endpoint.LEGAL_FORM,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      
      let model = try JSONDecoder().decode(LegalDocumentResponseModel.self, from: data)
      return model
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else { throw error }
      
      throw NetworkErrorMessage(
        code: error.code,
        description: error.description
      )
      
    }
    
  }
  
  public func fetchDocumentByID(
    headers: [String : String],
    id: String
  ) async throws -> DocumentByIDResponseModel {
    
    do {
      let data = try await service.request(
        with: Endpoint.LEGAL_FORM.appending("/\(id)"),
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      
      let model = try JSONDecoder().decode(DocumentByIDResponseModel.self, from: data)
      return model
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else { throw error }
      
      throw NetworkErrorMessage(
        code: error.code,
        description: error.description
      )
      
    }
    
  }
  
}
