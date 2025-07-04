//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 30/06/25.
//

import Foundation

public struct FilterCityKemenPPPARequestParam: Paramable, Equatable {

  let provinceId: Int?

  public func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if provinceId != 0 {
      parameters["province_id"] = provinceId
    }
    
    return parameters
  }
}
