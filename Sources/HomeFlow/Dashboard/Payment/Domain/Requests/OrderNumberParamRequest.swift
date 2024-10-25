//
//  OrderBookParamRequest.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public struct OrderNumberParamRequest: Paramable {
  public let orderNumber: String

  public func toParam() -> [String : Any] {
    return  ["order_no" : orderNumber]
  }
}
