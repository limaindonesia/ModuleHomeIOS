//
//  PaymentCancelationRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

import Foundation
import AprodhitKit
import GnDKit

public class PaymentCancelationRepository: PaymentCancelationRepositoryLogic {
  
  private let remote: PaymentCancelationRemoteDataSourceLogic
  
  public init(remote: PaymentCancelationRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func requestReasons(headers: HeaderRequest) async throws -> [ReasonEntity] {
    do {
      let response = try await remote.requestCancelationReason(headers: headers.toHeaders())
      return response.data?.map(ReasonEntity.map(from:)) ?? []
      
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
  
  public func requestCancelReason(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    do {
      let _ = try await remote.requestCancelReason(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return true
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
    }
  }
  
  public func requestPaymentCancel(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    do {
      let _ = try await remote.requestPaymentCancel(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return true
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
    }
  }
  
  public func requestDismissRefund(
    headers: AprodhitKit.HeaderRequest,
    parameters: DismissRefundRequest
  ) async throws -> Bool {
    do {
      let _ = try await remote.requestDismissRefund(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      return true
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
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
