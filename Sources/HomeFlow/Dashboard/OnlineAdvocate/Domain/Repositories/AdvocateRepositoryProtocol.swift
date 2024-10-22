//
//  AdvocateRepositoryProtocol.swift
//
//
//  Created by Ilham Prabawa on 23/09/24.
//

import Foundation

public protocol AdvocateRepositoryProtocol {

  func fetchAdvocates(parameters: [String: Any]) async throws -> AdvocateEntity

}
