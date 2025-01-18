//
//  BookingOrderParamRequest.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public struct BookingOrderParamRequest: Paramable {
  
  public let type: String
  public let lawyerId: Int
  public let skillId: Int
  public let description: String
  public let orderType: String
  
  public init(
    type: String,
    lawyerId: Int,
    skillId: Int,
    description: String,
    orderType: String
  ) {
    self.type = type
    self.lawyerId = lawyerId
    self.skillId = skillId
    self.description = description
    self.orderType = orderType
  }
  
  public func toParam() -> [String : Any] {
    let consultation: [String : Any] = [
      "lawyer_id" : lawyerId,
      "skill_id" : skillId,
      "description" : description,
      "order_type" : orderType
    ]
    
    return [
      "type" : type,
      "consultation" : consultation
    ]
  }
  
}
