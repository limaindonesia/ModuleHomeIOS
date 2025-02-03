//
//  EligibleVoucherParamRequests.swift.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 03/02/25.
//
import Foundation
import GnDKit
import AprodhitKit

public struct EligibleVoucherParamRequests: Paramable {
  public let orderNumber: String
  
  public init(orderNumber: String) {
    self.orderNumber = orderNumber
  }
  
  func toParam() -> [String : Any] {
    return ["order_no" : orderNumber]
  }
}
