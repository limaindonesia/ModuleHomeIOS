//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 13/01/25.
//


import Foundation

public struct OrderServiceResponseModel: Codable {
  var data: [OrderServiceItemData]
  var message: String?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.data = try container.decode([OrderServiceItemData].self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }

  public init() {
    self.data = []
    self.message = ""
  }

  enum CodingKeys: String, CodingKey {
    case data
    case message
  }
}

public struct OrderServiceItemData: Codable {
  let name: String?
  let type: String?
  let status: String? // ACTIVE | INACTIVE
  let duration: Int?
  let price: Int?
  let original_price: Int?
  let icon_url: String?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.type = try container.decodeIfPresent(String.self, forKey: .type)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
    self.price = try container.decodeIfPresent(Int.self, forKey: .price)
    self.original_price = try container.decodeIfPresent(Int.self, forKey: .original_price)
    self.icon_url = try container.decodeIfPresent(String.self, forKey: .icon_url)
  }

  public init() {
    self.name = ""
    self.type = ""
    self.status = ""
    self.duration = 0
    self.price = 0
    self.original_price = 0
    self.icon_url = ""
  }

  enum CodingKeys: String, CodingKey {
    case name
    case type
    case status
    case duration
    case price
    case original_price
    case icon_url
  }
}
