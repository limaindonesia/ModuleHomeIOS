//
//  CategoryParamRequest.swift
//
//
//  Created by Ilham Prabawa on 25/07/24.
//

import Foundation

public struct CategoryParamRequest: Paramable {

  let name: String

  func toParam() -> [String : Any] {
    return ["name": name]
  }

}
