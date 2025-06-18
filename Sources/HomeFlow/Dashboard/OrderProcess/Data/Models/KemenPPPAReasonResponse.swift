//
//  KemenPPPAReasonResponse.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

public struct KemenPPPAReasonResponse: Codable {
  public let success: Bool?
  public let data: [Data]?
  public let message: String?
  
  enum CodingKeys: String, CodingKey {
    case success = "success"
    case data = "data"
    case message = "message"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    success = try values.decodeIfPresent(Bool.self, forKey: .success)
    data = try values.decodeIfPresent([Data].self, forKey: .data)
    message = try values.decodeIfPresent(String.self, forKey: .message)
  }
  
  public struct Data: Codable {
    public let id: Int?
    public let reason: String?
    
    enum CodingKeys: String, CodingKey {
      case id = "id"
      case reason = "reason"
    }
    
    public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decodeIfPresent(Int.self, forKey: .id)
      reason = try values.decodeIfPresent(String.self, forKey: .reason)
    }
    
  }
  
}
