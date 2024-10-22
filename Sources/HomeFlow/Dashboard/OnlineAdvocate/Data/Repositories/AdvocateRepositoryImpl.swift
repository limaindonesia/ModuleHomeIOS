//
//  AdvocateRepository.swift
//
//
//  Created by Ilham Prabawa on 23/09/24.
//

import Foundation

public struct AdvocateRepositoryImpl: AdvocateRepositoryProtocol {

  private let remote: AdvocateRemoteDataSourceProtocol

  public init(remote: AdvocateRemoteDataSourceProtocol) {
    self.remote = remote
  }

  public func fetchAdvocates(parameters: [String : Any]) async throws -> AdvocateEntity {
    fatalError()
  }

}
