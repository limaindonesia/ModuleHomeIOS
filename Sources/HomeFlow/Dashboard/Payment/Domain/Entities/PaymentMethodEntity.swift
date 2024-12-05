//
//  PaymentMethodEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/12/24.
//

import Foundation
import GnDKit

public enum PaymentCategory {
  case VA
  case EWALLET
  
  public static func convert(_ method: String) -> PaymentCategory {
    return method == "VA" ? .VA : .EWALLET
  }
}

public struct PaymentMethodEntity: Transformable{
  
  typealias D = PaymentMethodResponseModel.PaymentMethod
  
  typealias E = PaymentMethodEntity
  
  typealias VM = PaymentMethodViewModel
  
  public let name: String
  public let icon: URL?
  public let category: PaymentCategory
  
  public init() {
    self.name = ""
    self.icon = nil
    self.category = .VA
  }
  
  public init(
    name: String,
    icon: URL?,
    category: PaymentCategory
  ) {
    self.name = name
    self.icon = icon
    self.category = category
  }
  
  static func mapTo(_ entity: PaymentMethodEntity) -> PaymentMethodViewModel {
    return PaymentMethodViewModel(
      name: entity.name,
      icon: entity.icon,
      category: entity.category
    )
  }
  
  static func map(from data: PaymentMethodResponseModel.PaymentMethod) -> PaymentMethodEntity {
    return PaymentMethodEntity(
      name: data.name ?? "",
      icon: URL(string: data.icon ?? ""),
      category: PaymentCategory.convert(data.category ?? "")
    )
  }
  
}
