//
//  PaymentMethodResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/12/24.
//

import Foundation

// MARK: - PaymentMethodResponseModel
public struct PaymentMethodResponseModel: Codable {
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
    let paymentMethod: [PaymentMethod]?
    
    enum CodingKeys: String, CodingKey {
      case paymentMethod = "payment_method"
    }
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.paymentMethod = try container.decodeIfPresent([PaymentMethod].self, forKey: .paymentMethod)
    }
  }
  
  // MARK: - PaymentMethod
  struct PaymentMethod: Codable {
    let name: String?
    let icon: String?
    let category: String?
    
    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
      self.category = try container.decodeIfPresent(String.self, forKey: .category)
    }
  }
  
}
