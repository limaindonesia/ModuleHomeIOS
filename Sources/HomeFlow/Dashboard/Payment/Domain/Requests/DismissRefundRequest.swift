//
//  DismissRefundRequest.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 20/12/24.
//


import Foundation

public struct DismissRefundRequest: Paramable {
  private let id: Int
  
  public init(id: Int) {
    self.id = id
  }
  
  func toParam() -> [String : Any] {
    return ["consultation_id" : id]
  }
}
