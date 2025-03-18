//
//  DocumentActiveViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit
import SwiftUI

public class DocumentActiveViewModel: DocumentBaseViewModel, ObservableObject {
  
  @Published public var timeRemaining: TimeInterval
  public let price: String
  public let status: DocumentStatus
  public var onPayment: () -> Void
  public var onTimerTimesUp: () -> Void
  
  public override init() {
    self.price = ""
    self.status = .ON_PROCESS
    self.timeRemaining = 0
    self.onPayment = {}
    self.onTimerTimesUp = {}
    
    super.init(
      type: .HISTORY,
      title: ""
    )
  }
  
  public init(
    type: DocumentRowType,
    title: String,
    status: DocumentStatus,
    timeRemaining: TimeInterval,
    price: String,
    onPayment: @escaping () -> Void,
    onTimerTimesUp: @escaping () -> Void
  ) {
    
    self.price = price
    self.onPayment = onPayment
    self.status = status
    self.timeRemaining = timeRemaining
    self.onTimerTimesUp = onTimerTimesUp
    
    super.init(
      type: type,
      title: title
    )
  }
  
}
