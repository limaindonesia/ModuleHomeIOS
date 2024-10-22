//
//  SKTMRepositoryLogic.swift
//  
//
//  Created by Ilham Prabawa on 15/10/24.
//

import Foundation
import AprodhitKit

public protocol SKTMRepositoryLogic {
  func fetchSKTM(headers: [String : String]) async throws -> ClientGetSKTM
}
