//
//  PaymentCheckRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import AprodhitKit
import GnDKit

public class PaymentCheckRepository: PaymentCheckRepositoryLogic {
  
  private let remote: PaymentCheckRemoteDataSourceLogic
  
  public init(remote: PaymentCheckRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func requestPaymentStatus(
    headers: HeaderRequest,
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity {
    
    do {
      let response = try await remote.requestPaymentStatus(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      guard let data = response.data else { fatalError() }
      return PaymentStatusEntity.map(from: data)
      
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
        title: "Failed",
        message: error.description
      )
    }
    
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {
    
    do {
      let response = try await remote.fetchOngoingUserCases(
        headers: headers,
        parameters: parameters.toParam()
      )
      
      return response.data
      
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
        title: "Failed",
        message: error.description
      )
    }
  }
  
}
