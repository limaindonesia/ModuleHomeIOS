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
  ) async throws -> [ConsultationHistoryEntity] {
    
    do {
      let json = try await remoteDataSource.requestConsultation(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      let consultations = json.data?.data?.map { model in
        ConsultationHistoryEntity(
          type: model.getType(),
          name: model.lawyer?.name ?? "",
          imageURL: URL(string: model.lawyer?.photoURL ?? ""),
          consultationStatus: .DONE,
          dateTime: model.waitingExpiredAt ?? "",
          issue: model.skill?.name ?? "",
          serviceType: model.serviceTypeName ?? "",
          price: model.lawyer?.price ?? "",
          waitingExpiredAt: model.waitingExpiredAt ?? ""
        )
      }
      
      return consultations ?? []
      
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
