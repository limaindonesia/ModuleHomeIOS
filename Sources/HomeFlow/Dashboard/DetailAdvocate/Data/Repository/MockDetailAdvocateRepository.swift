//
//  MockDetailAdvocateRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import GnDKit
import AprodhitKit

public class MockDetailAdvocateRepository: DetailAdvocateRepositoryLogic {
  
  public init() {}
  
  public func getDetailAdvocate(
    headers: HeaderRequest,
    parameters: DetailParameterRequest
  ) async throws -> AdvocateGetRespSingle {
    fatalError()
  }
  
  public func getLawyerReview(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerReviewListGetResp {
    fatalError()
  }
  
  public func getLawyerRating(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerRatingsGeneralGetResp {
    fatalError()
  }
}
