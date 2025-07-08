//
//  DetailAdvocateRepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import Foundation
import GnDKit
import AprodhitKit

public class DetailAdvocateRepositoryImpl: DetailAdvocateRepositoryLogic {
  
  private let remote: DetailAdvocateRemoteDataSourceLogic
  
  public init(remote: DetailAdvocateRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func getDetailAdvocate(
    headers: HeaderRequest,
    parameters: DetailParameterRequest
  ) async throws -> AdvocateGetRespSingle {
    
    do {
      let response = try await remote.getDetailAdvocate(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return response
      
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
        title: "Gagal",
        message: error.description
      )
    }
  }
  
  public func getLawyerReview(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerReviewListGetResp {
    do {
      let response = try await remote.getLawyerReview(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return response
      
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
        title: "Gagal",
        message: error.description
      )
    }
  }
  
  public func getLawyerRating(
    headers: HeaderRequest,
    parameters: ReviewParamRequest
  ) async throws -> LawyerRatingsGeneralGetResp {
    do {
      let response = try await remote.getLawyerRating(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return response
      
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
        title: "Gagal",
        message: error.description
      )
    }
  }
  
}
