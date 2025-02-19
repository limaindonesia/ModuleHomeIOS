//
//  OngoingConsultationViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation

public class OngoingConsultationViewModel: ConsultationBaseModel {
  
  public var status: ConsultationStatus
  public var timeRemaining: TimeInterval
  public var issues: String
  public var serviceName: String
  public var price: String
  public var backToConsultation: () -> Void
  
  public init(
    name: String,
    imageURL: URL?,
    type: ConsultationRowType,
    status: ConsultationStatus,
    timeRemaining: TimeInterval,
    issues: String,
    serviceName: String,
    price: String,
    backToConsultation: @escaping () -> Void
  ) {
    self.status = status
    self.timeRemaining = timeRemaining
    self.issues = issues
    self.serviceName = serviceName
    self.price = price
    self.backToConsultation = backToConsultation
    
    super.init(
      name: name,
      imageURL: imageURL,
      type: type
    )
  }
  
  public func getTimeString() -> String {
    return timeRemaining.timeString()
  }
  
}
