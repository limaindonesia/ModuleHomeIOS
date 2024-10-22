//
//  CategoryResponseModel.swift
//
//
//  Created by Ilham Prabawa on 25/07/24.
//

import Foundation

// MARK: - Welcome
public struct SkillResponseModel: Codable {
  let success: Bool?
  let data: [SkillData]?
  let message: String?

  // MARK: - Datum
  public struct SkillData: Codable {
    let id, parentID: Int?
    let iconURL: String?
    let name, description: String?
    let types: [TypeElement]?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
      case id
      case parentID = "parent_id"
      case iconURL = "icon_url"
      case name, description, types
      case createdAt = "created_at"
      case updatedAt = "updated_at"
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<SkillResponseModel.SkillData.CodingKeys> = try decoder.container(keyedBy: SkillResponseModel.SkillData.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: SkillResponseModel.SkillData.CodingKeys.id)
      self.parentID = try container.decodeIfPresent(Int.self, forKey: SkillResponseModel.SkillData.CodingKeys.parentID)
      self.iconURL = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.SkillData.CodingKeys.iconURL)
      self.name = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.SkillData.CodingKeys.name)
      self.description = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.SkillData.CodingKeys.description)
      self.types = try container.decodeIfPresent([SkillResponseModel.TypeElement].self, forKey: SkillResponseModel.SkillData.CodingKeys.types)
      self.createdAt = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.SkillData.CodingKeys.createdAt)
      self.updatedAt = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.SkillData.CodingKeys.updatedAt)
    }
  }

  // MARK: - TypeElement
  public struct TypeElement: Codable {
    let id: Int?
    let name, description: String?

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<SkillResponseModel.TypeElement.CodingKeys> = try decoder.container(keyedBy: SkillResponseModel.TypeElement.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: SkillResponseModel.TypeElement.CodingKeys.id)
      self.name = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.TypeElement.CodingKeys.name)
      self.description = try container.decodeIfPresent(String.self, forKey: SkillResponseModel.TypeElement.CodingKeys.description)
    }
  }

}

