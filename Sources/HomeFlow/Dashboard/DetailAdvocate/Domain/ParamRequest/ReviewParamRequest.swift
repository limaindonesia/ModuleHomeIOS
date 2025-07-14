//
//  ReviewParamRequest.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import GnDKit
import AprodhitKit

public struct ReviewParamRequest: Paramable {
  
  private let lawyerID: Int
  private let limit: Int
  private let page: Int
  
  public init(
    lawyerID: Int,
    limit: Int,
    page: Int
  ) {
    self.lawyerID = lawyerID
    self.limit = limit
    self.page = page
  }
  
  public func toParam() -> [String : Any] {
    return [
      "lawyer_id" : lawyerID,
      "limit" : limit,
      "page" : page
    ]
  }
  
}
