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
  public let status: String

  public init() {
    self.paymentURL = ""
    self.roomKey = ""
    self.status = ""
  }

  public init(
    paymentURL: String,
    roomKey: String,
    status: String
  ) {
    self.paymentURL = paymentURL
    self.roomKey = roomKey
    self.status = status
  }

  public func getPaymentURL() -> URL? {
    return URL(string: paymentURL)
  }

}
