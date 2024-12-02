//
//  MeResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/11/24.
//

import Foundation

// MARK: - MeResponseModel
public struct MeResponseModel: Codable {
  let success: Bool?
  let data: DataClass?
  let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  // MARK: - DataClass
  struct DataClass: Codable {
    let name, userType, usernameType, username: String?
    let verifiedAt, email, phone, status: String?
    let relation: Relation?
    
    enum CodingKeys: String, CodingKey {
      case name
      case userType = "user_type"
      case usernameType = "username_type"
      case username
      case verifiedAt = "verified_at"
      case email, phone, status, relation
    }
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.userType = try container.decodeIfPresent(String.self, forKey: .userType)
      self.usernameType = try container.decodeIfPresent(String.self, forKey: .usernameType)
      self.username = try container.decodeIfPresent(String.self, forKey: .username)
      self.verifiedAt = try container.decodeIfPresent(String.self, forKey: .verifiedAt)
      self.email = try container.decodeIfPresent(String.self, forKey: .email)
      self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
      self.status = try container.decodeIfPresent(String.self, forKey: .status)
      self.relation = try container.decodeIfPresent(Relation.self, forKey: .relation)
    }
  }
  
  // MARK: - Relation
  struct Relation: Codable {
    let id: Int?
    let name, photoURL, birthDate, gender: String?
    let address: Address?
    let profileCompletions: ProfileCompletions?
    let isCompleted: Bool?
    let orderNoExpired: String?
    
    enum CodingKeys: String, CodingKey {
      case id, name
      case photoURL = "photo_url"
      case birthDate = "birth_date"
      case gender, address
      case profileCompletions = "profile_completions"
      case isCompleted = "is_completed"
      case orderNoExpired = "order_no_expired"
    }
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
      self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
      self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
      self.address = try container.decodeIfPresent(Address.self, forKey: .address)
      self.profileCompletions = try container.decodeIfPresent(ProfileCompletions.self, forKey: .profileCompletions)
      self.isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted)
      self.orderNoExpired = try container.decodeIfPresent(String.self, forKey: .orderNoExpired)
    }
  }
  
  // MARK: - Address
  struct Address: Codable {
  }
  
  // MARK: - ProfileCompletions
  struct ProfileCompletions: Codable {
    let validationPercentage: Int?
    let validationMessage: String?
    let sectionValidations: [SectionValidation]?
    
    enum CodingKeys: String, CodingKey {
      case validationPercentage = "validation_percentage"
      case validationMessage = "validation_message"
      case sectionValidations = "section_validations"
    }
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.validationPercentage = try container.decodeIfPresent(Int.self, forKey: .validationPercentage)
      self.validationMessage = try container.decodeIfPresent(String.self, forKey: .validationMessage)
      self.sectionValidations = try container.decodeIfPresent([SectionValidation].self, forKey: .sectionValidations)
    }
  }
  
  // MARK: - SectionValidation
  struct SectionValidation: Codable {
    let section, message: String?
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.section = try container.decodeIfPresent(String.self, forKey: .section)
      self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
  }
  
}
