//
//  UserCasesParamRequest.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import Foundation

public enum ConsultationParamType: String {
  case ONGOING = "ongoing"
  case HISTORY = "history"
}

public struct UserCasesParamRequest: Paramable {
  
  private let type: ConsultationParamType
  private let limit: Int?
  private let skip: Int?
  private let status: String?
  private let q: String?
  private let paginate: Bool?
  private let page: Int?
  
  public init(
    type: ConsultationParamType,
    limit: Int? = nil,
    skip: Int? = nil,
    status: String? = nil,
    q: String? = nil,
    paginate: Bool? = nil,
    page: Int? = nil
  ) {
    self.type = type
    self.limit = limit
    self.skip = skip
    self.status = status
    self.q = q
    self.paginate = paginate
    self.page = page
  }
  
  public func toParam() -> [String : Any] {
    
    var params: [String : Any] = ["type" : type.rawValue]
    
    if limit != 0 {
      params["limit"] = limit
    }
    
    if skip != 0 {
      params["skip"] = skip
    }
    
    if let status = status {
      params["status"] = status
    }
    
    if let q = q {
      params["q"] = q
    }
    
    if let paginate = paginate {
      params["paginate"] = paginate
    }
    
    if let page = page {
      params["page"] = page
    }
    
    return params
  }
  
}
