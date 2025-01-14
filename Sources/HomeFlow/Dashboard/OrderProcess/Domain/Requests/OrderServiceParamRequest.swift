//
//  BookingOrderParamRequest.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public struct OrderServiceParamRequest: Paramable {

  public let lawyerSkillPriceId: String

  public init(
    lawyerSkillPriceId: String
  ) {
    self.lawyerSkillPriceId = lawyerSkillPriceId
  }

  func toParam() -> [String : Any] {
    return [
      "lawyer_skill_price_id" : lawyerSkillPriceId,
    ]
  }

}
