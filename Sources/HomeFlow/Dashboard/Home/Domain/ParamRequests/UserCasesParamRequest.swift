//
//  UserCasesParamRequest.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import Foundation

public struct UserCasesParamRequest: Paramable {

  private let type: String

  public init(type: String) {
    self.type = type
  }

  func toParam() -> [String : Any] {
    guard !type.isEmpty else {
      return [:]
    }
    
    return ["type" : type]
  }

}
