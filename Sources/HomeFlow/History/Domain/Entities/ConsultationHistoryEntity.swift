//
//  ConsultationHistoryEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public struct ConsultationHistoryEntity {
  
  public let id: Int
  public let orderNumber: String
  public let type: ConsultationRowType
  public let name: String
  public let imageURL: URL?
  public let consultationStatus: ConsultationStatus
  public let dateTime: String
  public let issue: String
  public let serviceType: String
  public let price: String
  public let waitingExpiredAt: String
  
  public func getTimeRemaining() -> TimeInterval {
    guard let expDate = waitingExpiredAt.toDate() else { return 0 }
    let time = Date().findMinutesDiff(with: expDate)
    return time < 0 ? 0 : time
  }
  
}
