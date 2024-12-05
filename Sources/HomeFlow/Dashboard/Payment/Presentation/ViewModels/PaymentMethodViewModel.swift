//
//  PaymentMethodViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/12/24.
//

import Foundation

public class PaymentMethodViewModel: Identifiable {
  public var id: UUID
  var name: String
  var icon: URL?
  var category: PaymentCategory
  
  public init(
    id: UUID = UUID(),
    name: String,
    icon: URL? = nil,
    category: PaymentCategory
  ) {
    self.id = id
    self.name = name
    self.icon = icon
    self.category = category
  }
}
