//
//  ReasonResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

import Foundation

// MARK: - ReasonResponseModel
public struct ReasonResponseModel: Codable {
  public let success: Bool?
  public let data: [Datum]?
  public let message: String?
  
  public init() {
    self.success = false
    self.data = []
    self.message = ""
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent([ReasonResponseModel.Datum].self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  // MARK: - Datum
  public struct Datum: Codable {
    public let id: Int?
    public let reason: String?
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }
  }
  
}



