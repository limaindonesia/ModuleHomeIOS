//
//  DetailAdvocateRepositoryLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import AprodhitKit
import GnDKit

public protocol DetailAdvocateRepositoryLogic {
  
  func getDetailAdvocate(
    headers: HeaderRequest,
    parameters: DetailParameterRequest
  ) async throws -> AdvocateGetRespSingle
  
  func getLawyerReview(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerReviewListGetResp
  
  func getLawyerRating(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerRatingsGeneralGetResp
  
}
