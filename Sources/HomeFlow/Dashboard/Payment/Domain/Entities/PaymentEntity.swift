//
//  PaymentEntity.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public struct PaymentEntity {
  
  public let urlString: String
  public let roomKey: String
  
  init(urlString: String, roomKey: String) {
    self.urlString = urlString
    self.roomKey = roomKey
  }
  
  public func getPaymentURL() -> URL? {
    return URL(string: urlString)
  }
  
}
