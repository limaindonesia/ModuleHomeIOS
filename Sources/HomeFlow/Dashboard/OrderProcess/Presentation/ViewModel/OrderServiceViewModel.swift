//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 13/01/25.
//

import Foundation

public struct OrderServiceViewModel {
  
  private let name: String
  private let type: String
  private let status: String // ACTIVE | INACTIVE
  private let duration: Int
  private let price: Int
  private let original_price: Int
  private let icon_url: String

  public init() {
    self.name = ""
    self.type = ""
    self.status = ""
    self.duration = 0
    self.price = 0
    self.original_price = 0
    self.icon_url = ""
  }

  public init(
    name: String,
    type: String,
    status: String,
    duration: Int,
    price: Int,
    original_price: Int,
    icon_url: String
  ) {
    self.name = name
    self.type = type
    self.status = status
    self.duration = duration
    self.price = price
    self.original_price = original_price
    self.icon_url = icon_url
  }

}
