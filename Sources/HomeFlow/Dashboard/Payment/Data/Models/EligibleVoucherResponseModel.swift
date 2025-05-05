//
//  EligibleVoucherResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 03/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public struct EligibleVoucherResponseModel: Codable {
  public let success: Bool?
  public let data: [Datum]?
  public let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent([Datum].self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  public struct Datum: Codable {
    public let name, code, tnc, endDate, status: String?
    public let quota: Int?
    
    enum CodingKeys: String, CodingKey {
      case name, code, tnc, quota, status
      case endDate = "end_date"
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.code = try container.decodeIfPresent(String.self, forKey: .code)
      self.tnc = try container.decodeIfPresent(String.self, forKey: .tnc)
      self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
      self.quota = try container.decodeIfPresent(Int.self, forKey: .quota)
      self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
  }
}


