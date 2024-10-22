//
//  AdvocateParamRequest.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import Foundation

protocol Paramable {
  func toParam() -> [String: Any]
}

public struct AdvocateParamRequest: Paramable, Equatable {

  let isOnline: Bool?

  func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if let isOnline = isOnline {
      parameters["is_online"] = isOnline
    }

    return parameters
  }
}
