//
//  OngoingRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/11/24.
//

import AprodhitKit
import GnDKit

public protocol OngoingRepositoryLogic {
  
  func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases]
  
}
