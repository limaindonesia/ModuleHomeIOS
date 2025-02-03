//
//  PaymentRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct PaymentRepository: PaymentRepositoryLogic,
                                 OngoingRepositoryLogic {
  
  private let remote: PaymentRemoteDataSourceLogic & OngoingUserCaseRemoteDataSourceLogic
  
  public init(remote: PaymentRemoteDataSourceLogic & OngoingUserCaseRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderEntity {
    
    do {
      let json = try await remote.requestOrderByNumber(
        headers.toHeaders(),
        parameters.toParam()
      )
      
      let entity = json.data.map(OrderEntity.map(from:))!
      return entity
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
  
  public func requestUseVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> VoucherEntity {
    do {
      let json = try await remote.requestUseVoucher(
        headers.toHeaders(),
        parameters.toParam()
      )
      
      return VoucherEntity.map(from: json)
      
    } catch {
      guard let error = error as? NetworkErrorMessage else {
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
  
  public func requestCreatePayment(
    headers: HeaderRequest,
    parameters: PaymentParamRequest
  ) async throws -> PaymentEntity {
    do {
      let json = try await remote.requestCreatePayment(
        headers.toHeaders(),
        parameters.toParam()
      )
      
      let data = json.data
      let entity = PaymentEntity(
        urlString: data?.paymentURL ?? "",
        roomKey: data?.roomKey ?? ""
      )
      
      return entity
      
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
  
  public func requestRemoveVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> Bool {
    do {
      let _ = try await remote.requestRemoveVoucher(
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
  
  public func requestRejectionPayment(
    headers: HeaderRequest,
    parameters: PaymentRejectionRequest
  ) async throws -> Bool {
    
    do {
      let response = try await remote.requestRejectionPayment(
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
        title: "Failed",
        message: error.description
      )
    }
    
  }
  
  public func requestPaymentMethod(headers: HeaderRequest) async throws -> [PaymentMethodEntity] {
    do {
      let response = try await remote.requestPaymentMethods(headers: headers.toHeaders())
      guard let methods = response.data?.paymentMethod else {
        return []
      }
      
      return methods.map(PaymentMethodEntity.map(from:))
      
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
  
  public func requestEligibleVoucher(
    headers: HeaderRequest,
    parameters: EligibleVoucherParamRequests
  ) async throws -> [EligibleVoucherEntity] {
    do {
      let response = try await remote.requestEligibleVoucher(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      guard let methods = response.data else {
        return []
      }
      
      return methods.map(EligibleVoucherEntity.map(from:))
      
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
