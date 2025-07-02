//
//  OngoingRepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 02/07/25.
//

import AprodhitKit
import GnDKit

public class OngoingRepositoryImpl: OngoingRepositoryLogic {
  
  private let remote: OngoingUserCaseRemoteDataSourceLogic
  
  public init(remote: OngoingUserCaseRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {
    
    do {
      let response = try await remote.fetchOngoingUserCases(
        headers: headers,
        parameters: parameters.toParam()
      )
      
      return response.data
      
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
        title: "Failed",
        message: error.description
      )
    }
  }
  
}
