//
//  OrderNumberResponseModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public struct OrderNumberResponseModel: Codable {
  public let success: Bool?
  public let data: DataClass?
  public let message: String?

  enum CodingKeys: CodingKey {
    case success
    case data
    case message
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }

  public struct DataClass: Codable {
    public let orderItems: OrderItems?
    public let totalAmount: String?
    public let paymentMethod: [PaymentMethod]
    public let expiredAt: String?

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.orderItems = try container.decodeIfPresent(OrderItems.self, forKey: .orderItems)
      self.totalAmount = try container.decodeIfPresent(String.self, forKey: .totalAmount)
      self.paymentMethod = try container.decode([PaymentMethod].self, forKey: .paymentMethod)
      self.expiredAt = try container.decodeIfPresent(String.self, forKey: .expiredAt)
    }

  }

  public struct OrderItems: Codable{
    public let lawyerFee, adminFee, discount: String?

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.lawyerFee = try container.decodeIfPresent(String.self, forKey: .lawyerFee)
      self.adminFee = try container.decodeIfPresent(String.self, forKey: .adminFee)
      self.discount = try container.decodeIfPresent(String.self, forKey: .discount)
    }
  }

  public struct PaymentMethod: Codable {
    public let name: String?
    public let icon: String?

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
  }


}
