//
//  TreatmentRemoteDataSourceLogic.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol TreatmentRemoteDataSourceLogic {

  func fetchTreatments() async throws -> TreatmentResponseModel

}

public struct TreatmentRemoteDataSource: TreatmentRemoteDataSourceLogic {

  private let service: NetworkServiceLogic

  public init(service: NetworkServiceLogic) {
    self.service = service
  }

  public func fetchTreatments() async throws -> TreatmentResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.TREATMENT,
        withMethod: .get,
        withHeaders: [:],
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(TreatmentResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }

  }

}
