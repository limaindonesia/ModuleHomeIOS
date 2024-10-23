//
//  CategoryViewModel.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation

public struct CategoryViewModel {

  public let id: Int
  public let name: String

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(
    id: Int,
    name: String
  ) {
    self.id = id
    self.name = name
  }

}
