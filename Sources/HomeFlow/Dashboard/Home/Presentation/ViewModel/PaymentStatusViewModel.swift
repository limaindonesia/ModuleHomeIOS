//
//  PaymentStatusViewModel.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import Foundation

public class PaymentStatusViewModel {

  private let paymentURL: String
  public let roomKey: String

  public init() {
    self.paymentURL = ""
    self.roomKey = ""
  }

  public init(
    paymentURL: String,
    roomKey: String
  ) {
    self.paymentURL = paymentURL
    self.roomKey = roomKey
  }

  public func getPaymentURL() -> URL? {
    return URL(string: paymentURL)
  }

}
