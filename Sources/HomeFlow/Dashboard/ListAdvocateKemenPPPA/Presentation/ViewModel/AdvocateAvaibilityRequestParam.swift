//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 30/06/25.
//


import Foundation

public struct AdvocateAvaibilityRequestParam: Paramable, Equatable {

  let clientUsername: String?
  let lawyerID: String?
  

  public func toParam() -> [String : Any] {

    var parameters: [String: Any] = [:]

    if let clientUsername = clientUsername {
      parameters["client_username"] = clientUsername
    }
    
    if let lawyerID = lawyerID {
      parameters["lawyer_id"] = lawyerID
    }
    
    return parameters
  }
}
