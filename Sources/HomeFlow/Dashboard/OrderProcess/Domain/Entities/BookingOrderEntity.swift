//
//  repository.requestBookingOrder(bookingOrderParamRequest).swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public struct BookingOrderEntity {

  public let orderNumber: String

  public init() {
    self.orderNumber = ""
  }

  public init(orderNumber: String) {
    self.orderNumber = orderNumber
  }

}
