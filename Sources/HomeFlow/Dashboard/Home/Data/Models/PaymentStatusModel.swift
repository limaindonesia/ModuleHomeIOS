//
//  PaymentStatusModel.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import Foundation

public struct PaymentStatusModel: Codable {
  public var success: Bool?
  public var data: PaymentStatusModelData?
  public var message: String?

  init() {
    self.success = false
    self.message = ""
    self.data = .init()
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(PaymentStatusModelData.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }

}

public struct PaymentStatusModelData: Codable {
  public var payment_url: String?
  public var room_key: String?
  public var status: String?

  init() {
    self.payment_url = ""
    self.room_key = ""
    self.status = ""
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.payment_url = try container.decodeIfPresent(String.self, forKey: .payment_url)
    self.room_key = try container.decodeIfPresent(String.self, forKey: .room_key)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
  }
}
