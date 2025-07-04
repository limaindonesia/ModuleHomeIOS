//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import Foundation

public struct ListKemenPPPARequestParam: Paramable, Equatable {

  let limit: Int?
  let skip: Int?
  let cities: [Int]?
  let provinces: [Int]?
  let userName: String?

  public func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if userName ?? "" != "" {
      parameters["user.name"] = userName
    }
    if let limit = limit {
      parameters["limit"] = limit
    }
    if skip ?? 0 > 0 {
      parameters["skip"] = skip
    }
    if let cities = cities {
      parameters["city_ids"] = cities
    }
    if let provinces = provinces {
      parameters["agencyProvince_ids"] = provinces
    }
    parameters["is_kemenpppa"] = true

    return parameters
  }
}
