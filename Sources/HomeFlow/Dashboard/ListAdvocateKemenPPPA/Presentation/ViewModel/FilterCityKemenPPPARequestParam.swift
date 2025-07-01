//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 30/06/25.
//

import Foundation

public struct FilterCityKemenPPPARequestParam: Paramable, Equatable {

  let provinceId: Int?

  func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if let provinceId = provinceId {
      parameters["province_id"] = provinceId
    }
    
    return parameters
  }
}
