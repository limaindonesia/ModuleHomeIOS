//
//  PaymentResponseModel.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public struct PaymentResponseModel: Codable {
  public let success: Bool?
  public let data: DataClass?
  public let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(PaymentResponseModel.DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  public struct DataClass: Codable {
    public let paymentURL: String?
    public let roomKey: String?
    
    enum CodingKeys: String, CodingKey {
      case paymentURL = "payment_url"
      case roomKey = "room_key"
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<PaymentResponseModel.DataClass.CodingKeys> = try decoder.container(keyedBy: PaymentResponseModel.DataClass.CodingKeys.self)
      self.paymentURL = try container.decodeIfPresent(String.self, forKey: PaymentResponseModel.DataClass.CodingKeys.paymentURL)
      self.roomKey = try container.decodeIfPresent(String.self, forKey: PaymentResponseModel.DataClass.CodingKeys.roomKey)
    }
  }
  
}
