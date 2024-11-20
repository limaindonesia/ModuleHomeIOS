//
//  PaymentRejectionRequest.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/11/24.
//

import Foundation

public struct PaymentRejectionRequest: Paramable {
  private let id: Int
  
  public init(id: Int) {
    self.id = id
  }
  
  func toParam() -> [String : Any] {
    return ["id" : id]
  }
}
