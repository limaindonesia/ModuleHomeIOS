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
  public let onTapButton: () -> Void
  
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
