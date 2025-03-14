//
//  CancelReasonRequestParams.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 11/03/25.
//

import Foundation
import GnDKit
import AprodhitKit

public struct CancelReasonRequestParams: Paramable {
  
  private let type: String?
  
  public init(type: String? = nil) {
    self.type = type
  }
  
  
  func toParam() -> [String : Any] {
    if let type = type {
      return ["order_type" : type]
    }
    
    return [:]
  }
  
}
