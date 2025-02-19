//
//  DocumentActiveViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class DocumentActiveViewModel: DocumentBaseViewModel {
  
  public let price: String
  public let status: DocumentStatus
  public let timeRemaining: TimeInterval
  public let onPayment: () -> Void
  
  public init(
    type: DocumentRowType,
    title: String,
    status: DocumentStatus,
    timeRemaining: TimeInterval,
    price: String,
    onPayment: @escaping () -> Void
  ) {
    
    self.price = price
    self.onPayment = onPayment
    self.status = status
    self.timeRemaining = timeRemaining
    
    super.init(
      type: type,
      title: title
    )
  }
  
}
