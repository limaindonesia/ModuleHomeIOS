//
//  HistoryConsultationViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation

public class HistoryConsultationViewModel: ConsultationBaseModel {
  
  public var status: ConsultationStatus
  public var date: String
  public var issues: String
  public var serviceName: String
  public var price: String
  public var readSummaries: () -> Void
  
  public override init() {
    self.status = .DONE
    self.date = ""
    self.issues = ""
    self.serviceName = ""
    self.price = ""
    self.readSummaries = {}
    
    super.init(
      name: "",
      imageURL: nil,
      type: .HISTORY
    )
  }
  
  public init(
    name: String,
    imageURL: URL?,
    type: ConsultationRowType,
    status: ConsultationStatus,
    serviceName: String,
    date: String,
    issues: String,
    price: String,
    readSummaries: @escaping () -> Void
  ) {
    self.status = status
    self.date = date
    self.issues = issues
    self.serviceName = serviceName
    self.price = price
    self.readSummaries = readSummaries
    
    super.init(
      name: name,
      imageURL: imageURL,
      type: type
    )
  }
  
  public func dateStr() -> String {
    guard let date = date.toDate() else { return "" }
    return date.stringFormat()
  }
  
}
