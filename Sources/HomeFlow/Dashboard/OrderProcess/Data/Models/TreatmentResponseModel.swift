//
//  Session.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation

public struct TreatmentResponseModel: Codable {
  var data: [Session]
  var message: String?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.data = try container.decode([Session].self, forKey: .data)
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

public struct Session: Codable {
  var duration: Int?
  var name: String?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }

  public init() {
    self.duration = 0
    self.name = ""
  }

  enum CodingKeys: String, CodingKey {
    case duration
    case name
  }
}
