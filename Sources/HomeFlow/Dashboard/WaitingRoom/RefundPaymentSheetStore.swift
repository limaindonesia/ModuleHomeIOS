//
//  RefundConsultationStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/12/24.
//

import Foundation
import GnDKit
import AprodhitKit

public class RefundPaymentSheetStore: SheetStore {
  
  let category: PaymentCategory
  let title: String
  let price: String
  let reasonDescriptions: String
  let buttonTitle: String
  var buttonAction: () -> Void
  
  public init(
    category: PaymentCategory,
    title: String,
    price: String,
    reasonDescriptions: String,
    buttonTitle: String,
    buttonAction: @escaping () -> Void
  ) {
    self.category = category
    self.title = title
    self.price = price
    self.reasonDescriptions = reasonDescriptions
    self.buttonTitle = buttonTitle
    self.buttonAction = buttonAction
  }
  
  public required init() {
    self.category = .EWALLET
    self.title = ""
    self.price = ""
    self.reasonDescriptions = ""
    self.buttonTitle = ""
    self.buttonAction = {}
  }
  
}
