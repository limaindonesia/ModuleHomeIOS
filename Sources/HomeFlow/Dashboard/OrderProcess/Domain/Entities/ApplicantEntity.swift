//
//  ApplicantEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

public struct ApplicantEntity: Identifiable, Equatable {
  
  public let id: Int
  public let title: String
  
  public init() {
    self.id = 0
    self.title = ""
  }
  
  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
  
}
