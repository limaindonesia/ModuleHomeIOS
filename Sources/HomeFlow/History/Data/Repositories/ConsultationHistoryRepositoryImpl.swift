//
//  HistoryConsultationRepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/02/25.
//

import Foundation
import GnDKit
import AprodhitKit

public class ConsultationHistoryRepositoryImpl: ConsultationHistoryRepositoryLogic {
  
  //Dependencies
  private let remoteDataSource: ConsultationHistoryRemoteDataSourceLogic
  
  public init(remoteDataSource: ConsultationHistoryRemoteDataSourceLogic) {
    self.remoteDataSource = remoteDataSource
  }
  
  public func getConsultations(
    headers: HeaderRequest,
    parameters: UserCasesParamRequest
  ) async throws -> ([ConsultationHistoryEntity], [UserCases]) {
    
    do {
      let json = try await remoteDataSource.requestConsultation(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      let consultations = json.data?.data?.map { model in
        ConsultationHistoryEntity(
          id: model.id ?? 0,
          orderNumber: model.order_no ?? "",
          type: model.getType(),
          name: model.lawyer?.name ?? "",
          imageURL: model.lawyer?.getImageName(),
          consultationStatus: .DONE,
          dateTime: model.waiting_expired_at ?? "",
          issue: model.skill?.name ?? "",
          serviceType: model.service_type_name ?? "",
          price: model.lawyer?.price ?? "",
          waitingExpiredAt: model.waiting_expired_at ?? ""
        )
      }
      
      let arrayOfConsultations = consultations ?? []
      let arrayOfUserCases = json.data?.data ?? []
      
      return (arrayOfConsultations, arrayOfUserCases)
      
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
