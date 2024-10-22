//
//  TopAdvocateResponseModel.swift
//
//
//  Created by Ilham Prabawa on 26/07/24.
//

import Foundation

public struct TopAdvocateResponseModel: Codable {

  let pos, lawyerID: Int?
  let name: String?
  let image: String?
  let agency: String?
  let yearExp: Int?

  enum CodingKeys: String, CodingKey {
    case pos
    case lawyerID = "lawyerId"
    case name, image, agency, yearExp
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.pos = try container.decodeIfPresent(Int.self, forKey: .pos)
    self.lawyerID = try container.decodeIfPresent(Int.self, forKey: .lawyerID)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.image = try container.decodeIfPresent(String.self, forKey: .image)
    self.agency = try container.decodeIfPresent(String.self, forKey: .agency)
    self.yearExp = try container.decodeIfPresent(Int.self, forKey: .yearExp)
  }

}
