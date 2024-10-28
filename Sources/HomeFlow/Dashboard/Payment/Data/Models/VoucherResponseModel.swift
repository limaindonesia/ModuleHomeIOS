//
//  VoucherResponseModel.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public struct VoucherResponseModel: Codable {
  public let success: Bool?
  public let data: DataClass?
  public let message: String?
  
  public init() {
    self.success = false
    self.data = .init()
    self.message = ""
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(VoucherResponseModel.DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  public struct DataClass: Codable {
    public let code, amount, tnc, description: String?
    public let duration: Int?
    
    public init(){
      self.code = ""
      self.amount = ""
      self.tnc = ""
      self.description = ""
      self.duration = 0
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<VoucherResponseModel.DataClass.CodingKeys> = try decoder.container(keyedBy: VoucherResponseModel.DataClass.CodingKeys.self)
      self.code = try container.decodeIfPresent(String.self, forKey: VoucherResponseModel.DataClass.CodingKeys.code)
      self.amount = try container.decodeIfPresent(String.self, forKey: VoucherResponseModel.DataClass.CodingKeys.amount)
      self.tnc = try container.decodeIfPresent(String.self, forKey: VoucherResponseModel.DataClass.CodingKeys.tnc)
      self.description = try container.decodeIfPresent(String.self, forKey: VoucherResponseModel.DataClass.CodingKeys.description)
      self.duration = try container.decodeIfPresent(Int.self, forKey: VoucherResponseModel.DataClass.CodingKeys.duration)
    }
  }
  
}

