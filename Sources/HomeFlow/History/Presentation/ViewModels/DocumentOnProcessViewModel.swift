//
//  DocumentOnProcessViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class DocumentOnProcessViewModel: DocumentBaseViewModel {
  
  public let price: String
  public let status: DocumentStatus
  public let date: String
  public let onNext: () -> Void
  
  public override init() {
    self.price = ""
    self.onNext = {}
    self.status = .ON_PROCESS
    self.date = ""
    
    super.init(
      type: .HISTORY,
      title: ""
    )
  }
  
  public init(
    type: DocumentRowType,
    title: String,
    status: DocumentStatus,
    date: String,
    price: String,
    onNext: @escaping () -> Void
  ) {
    
    self.price = price
    self.onNext = onNext
    self.status = status
    self.date = date
    
    super.init(
      type: type,
      title: title
    )
  }
  
  public func dateStr() -> String {
    guard let date = date.toDate() else { return "" }
    return date.stringFormat()
  }
  
}
