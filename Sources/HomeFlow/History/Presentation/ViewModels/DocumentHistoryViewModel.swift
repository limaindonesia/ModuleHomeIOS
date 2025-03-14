//
//  DocumentHistoryViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class DocumentHistoryViewModel: DocumentBaseViewModel {
  
  public let price: String
  public let status: DocumentStatus
  public let date: String
  public let onNext: () -> Void
  public let onTapButton: () -> Void
  
  public override init() {
    self.price = ""
    self.onNext = {}
    self.status = .DONE
    self.date = ""
    self.onTapButton = {}
    
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
    onNext: @escaping () -> Void,
    onTapButton: @escaping () -> Void
  ) {
    
    self.price = price
    self.onNext = onNext
    self.status = status
    self.date = date
    self.onTapButton = onTapButton
    
    super.init(
      type: type,
      title: title
    )
  }
  
}
