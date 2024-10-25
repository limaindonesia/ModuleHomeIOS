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
  public let useProbono: Bool

  public init(
    type: String,
    lawyerId: Int,
    skillId: Int,
    description: String,
    useProbono: Bool
  ) {
    self.type = type
    self.lawyerId = lawyerId
    self.skillId = skillId
    self.description = description
    self.useProbono = useProbono
  }

  func toParam() -> [String : Any] {
    let consultation: [String : Any] = [
      "lawyer_id" : lawyerId,
      "skill_id" : skillId,
      "description" : description,
      "use_probono" : useProbono
    ]

    return [
      "type": "",
      "consultation" : consultation
    ]
  }

}
