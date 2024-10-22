//
//  AdvocateRemoteDataSourceProtocol.swift
//
//
//  Created by Ilham Prabawa on 23/09/24.
//

import Foundation
import AprodhitKit

public protocol AdvocateRemoteDataSourceProtocol {

  func fetchAdvocates(parameters: [String: Any]) async throws -> AdvocateResponseModel

}

public struct AdvocateRemoteDataSourceImpl: AdvocateRemoteDataSourceProtocol {

  private let network: NetworkServiceLogic

  public init(network: NetworkServiceLogic) {
    self.network = network
  }

  public func fetchAdvocates(parameters: [String : Any]) async throws -> AdvocateResponseModel {
    let data = try await network.request(
      with: Endpoint.LAWYER_LIST,
      withMethod: .post,
      withHeaders: [:],
      withParameter: parameters,
      withEncoding: .url
    )

    do {
      let json = try JSONDecoder().decode(AdvocateResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }

  }

}
