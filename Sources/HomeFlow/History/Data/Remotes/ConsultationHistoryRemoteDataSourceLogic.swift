//
//  HistoryConsultationRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/02/25.
//

import Foundation
import GnDKit
import AprodhitKit

//limit: Int?,
//skip: Int?,
//type: String?,
//status: String?,
//q: String?,
//paginate: Bool

public protocol ConsultationHistoryRemoteDataSourceLogic {
  
  func requestConsultation(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> ConsultationHistoryResponse
  
}
