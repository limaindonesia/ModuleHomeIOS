//
//  BioEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/11/24.
//

import Foundation

public struct BioEntity {
  
  public let orderNumber: String
  
  public init() {
    self.orderNumber = ""
  }
  
  public init(orderNumber: String) {
    self.orderNumber = orderNumber
  }
  
}
