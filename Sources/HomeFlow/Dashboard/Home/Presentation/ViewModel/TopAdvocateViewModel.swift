//
//  TopAdvocateViewModel.swift
//
//
//  Created by Ilham Prabawa on 26/07/24.
//

import Foundation

public struct TopAdvocateViewModel: Identifiable, Equatable {

  public var position: Int
  public var id: Int
  private var image: String
  public var name: String
  public var agency: String
  public var experience: Int

  public init(
    position: Int,
    id: Int,
    image: String,
    name: String,
    agency: String,
    experience: Int
  ) {
    self.position = position
    self.id = id
    self.image = image
    self.name = name
    self.agency = agency
    self.experience = experience
  }

  public func getImageURL() -> URL? {
    return URL(string: image)
  }

}
