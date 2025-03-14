//
//  ConsultationHistoryRemoteDataSourceImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class ConsultationHistoryRemoteDataSourceImpl: ConsultationHistoryRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func requestConsultation(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> ConsultationHistoryResponse {
    
    do {
      let data = try await service.request(
        with: Endpoint.USER_CASES,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      
      let model = try JSONDecoder().decode(ConsultationHistoryResponse.self, from: data)
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
