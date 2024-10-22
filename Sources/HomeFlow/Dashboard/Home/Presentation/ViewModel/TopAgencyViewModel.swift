//
//  TopAgencyViewModel.swift
//
//
//  Created by Ilham Prabawa on 30/07/24.
//

import Foundation

public struct TopAgencyViewModel: Equatable {

  public let position: Int
  public let name: String
  public let location: String

  public init(
    position: Int,
    name: String,
    location: String
  ) {
    self.position = position
    self.name = name
    self.location = location
  }

  public func getIconName(by position: Int) -> String {
    let dictionary = [
      1 : "one",
      2 : "two",
      3 : "three"
    ]

    return "ranking_\(dictionary[position]!)"
  }

  public func getName() -> String {
    return "\(name) \(location)"
  }

  public func getPositionImage(from position: Int) -> String {
    let dictionary = [
      1 : "one",
      2 : "two",
      3 : "three"
    ]

    return dictionary[position]!
  }
}
