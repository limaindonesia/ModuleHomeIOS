//
//  OrderServiceViewModel.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 13/01/25.
//

import Foundation

public struct OrderServiceViewModel: Identifiable {
  
  public let id: Int
  public let name: String
  public let type: String
  public let status: String // ACTIVE | INACTIVE
  public let duration: String
  public let price: String
  public let originalPrice: String
  public let iconURL: String
  //
  public let isDiscount: Bool
  public let isSKTM: Bool
  public let isHaveQuotaSKTM: Bool
  public let quotaSKTM: Int
  public let isKTPActive: Bool
  public let isSaving: Bool
  public var isSelected: Bool
  public let descPrice: String
  public let discountPrice: String

  public init() {
    self.id = 0
    self.name = ""
    self.type = ""
    self.status = ""
    self.duration = ""
    self.price = ""
    self.originalPrice = ""
    self.iconURL = ""
    self.isDiscount = false
    self.isSKTM = false
    self.isHaveQuotaSKTM = false
    self.quotaSKTM = 0
    self.isKTPActive = false
    self.isSaving = false
    self.isSelected = false
    self.descPrice = ""
    self.discountPrice = ""
  }

  public init(
    id: Int,
    name: String,
    type: String,
    status: String,
    duration: String,
    price: String,
    originalPrice: String,
    iconURL: String,
    isDiscount: Bool,
    isSKTM: Bool,
    isHaveQuotaSKTM: Bool,
    quotaSKTM: Int,
    isKTPActive: Bool,
    isSaving: Bool,
    isSelected: Bool,
    descPrice: String,
    discountPrice: String
  ) {
    self.id = id
    self.name = name
    self.type = type
    self.status = status
    self.duration = duration
    self.price = price
    self.originalPrice = originalPrice
    self.iconURL = iconURL
    self.isDiscount = isDiscount
    self.isSKTM = isSKTM
    self.isHaveQuotaSKTM = isHaveQuotaSKTM
    self.quotaSKTM = quotaSKTM
    self.isKTPActive = isKTPActive
    self.isSaving = isSaving
    self.isSelected = isSelected
    self.descPrice = descPrice
    self.discountPrice = discountPrice
  }

}
