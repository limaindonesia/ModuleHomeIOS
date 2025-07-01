//
//  ViolenceCategoryEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

public struct ViolenceCategoryEntity: Identifiable, Equatable {
  public let id: Int
  public let title: String
  public let description: String
  
  public init() {
    self.id = 0
    self.title = ""
    self.description = ""
  }
  
  public init(
    id: Int,
    title: String,
    description: String
  ) {
    self.id = id
    self.title = title
    self.description = description
  }
}
