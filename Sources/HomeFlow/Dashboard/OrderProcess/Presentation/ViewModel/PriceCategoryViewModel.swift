//
//  PriceCategoryViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/11/24.
//

import Foundation

public struct PriceCategoryViewModel: Identifiable {
  public var id: Int
  public let title: String
  public let price: String
  public let originalPrice: String
  public let isDiscount: Bool
  public let isProbono: Bool
  public let categories: [CategoryViewModel]
  
  private init() {
    self.id = 0
    self.title = ""
    self.price = ""
    self.originalPrice = ""
    self.isDiscount = false
    self.isProbono = false
    self.categories = []
  }
  
  public init(
    id: Int,
    title: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Bool,
    categories: [CategoryViewModel]
  ) {
    self.id = id
    self.title = title
    self.price = price
    self.originalPrice = originalPrice
    self.isDiscount = isDiscount
    self.isProbono = isProbono
    self.categories = categories
  }
  
}
