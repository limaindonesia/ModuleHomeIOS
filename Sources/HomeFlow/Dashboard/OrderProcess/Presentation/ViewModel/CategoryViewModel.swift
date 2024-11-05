//
//  CategoryViewModel.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation

public class CategoryViewModel: Hashable {
  
  public var id: Int
  public var name: String
  
  public init() {
    self.id = 0
    self.name = ""
  }
  
  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  public func setID(_ id: Int) {
    self.id = id
  }
  
  public func setName(_ name: String) {
    self.name = name
  }
  
  public static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
}
