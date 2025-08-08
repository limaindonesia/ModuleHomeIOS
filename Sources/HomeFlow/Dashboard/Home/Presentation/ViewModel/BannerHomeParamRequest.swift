//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 01/08/25.
//

import Foundation

public struct BannerHomeParamRequest: Paramable, Equatable {

  let isActive: Bool?
  let sort: String?
  
  public func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if let isActive = isActive {
      parameters["is_active"] = isActive
    }
    if let sort = sort {
      parameters["sort"] = sort
    }

    return parameters
  }
}
