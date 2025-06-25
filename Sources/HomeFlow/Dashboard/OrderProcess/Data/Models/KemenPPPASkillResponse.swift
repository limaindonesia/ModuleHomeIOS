//
//  KemenPPPASkillResponse.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 25/06/25.
//

import Foundation
import GnDKit

public struct KemenPPPASkillResponse: Codable {
  public let success: Bool?
  public let data: [Datum]?
  public let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent([KemenPPPASkillResponse.Datum].self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  public struct Datum: Codable {
    public let id, parentID: Int?
    public let iconURL: String?
    public let name, description, createdAt, updatedAt: String?
    public let types: [JSONAny]?
    public let codeName, skillType: String?
    
    enum CodingKeys: String, CodingKey {
      case id
      case parentID = "parent_id"
      case iconURL = "icon_url"
      case name, description
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case types
      case codeName = "code_name"
      case skillType = "skill_type"
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<KemenPPPASkillResponse.Datum.CodingKeys> = try decoder.container(keyedBy: KemenPPPASkillResponse.Datum.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.id)
      self.parentID = try container.decodeIfPresent(Int.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.parentID)
      self.iconURL = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.iconURL)
      self.name = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.name)
      self.description = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.description)
      self.createdAt = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.createdAt)
      self.updatedAt = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.updatedAt)
      self.types = try container.decodeIfPresent([JSONAny].self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.types)
      self.codeName = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.codeName)
      self.skillType = try container.decodeIfPresent(String.self, forKey: KemenPPPASkillResponse.Datum.CodingKeys.skillType)
    }
  }
  
}

