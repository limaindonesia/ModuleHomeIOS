//
//  OngoingUserCaseRemoteDataSource.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/11/24.
//

import AprodhitKit

public protocol OngoingUserCaseRemoteDataSourceLogic {
  
  func fetchOngoingUserCases(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> UserCasesGetResp
  
}
