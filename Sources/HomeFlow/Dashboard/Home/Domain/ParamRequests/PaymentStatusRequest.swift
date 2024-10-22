//
//  PaymentStatusRequest.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import Foundation

public struct PaymentStatusRequest: Paramable {

  private let orderNumber: String

  public init(orderNumber: String) {
    self.orderNumber = orderNumber
  }

  func toParam() -> [String : Any] {
    return ["order_no" : orderNumber]
  }

}
