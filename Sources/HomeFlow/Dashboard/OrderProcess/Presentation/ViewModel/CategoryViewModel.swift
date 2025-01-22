//
//  CategoryViewModel.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation

public struct CategoryViewModel: Identifiable, Hashable {
  
  public var id: Int
  public var lawyerSkillPriceId: Int
  public let skillId: Int
  public let name: String
  public let caseExample: String
  public let price: String
  public let originalPrice: String
  public var isSelected: Bool
  
  public init() {
    self.id = 0
    self.lawyerSkillPriceId = 0
    self.skillId = 0
    self.name = ""
    self.caseExample = ""
    self.price = ""
    self.originalPrice = ""
    self.isSelected = false
  }
  
  public init(
    id: Int,
    lawyerSkillPriceId: Int,
    skillId: Int,
    name: String,
    caseExample: String,
    price: String,
    originalPrice: String,
    isSelected: Bool
  ) {
    self.id = id
    self.lawyerSkillPriceId = lawyerSkillPriceId
    self.skillId = skillId
    self.name = name
    self.caseExample = caseExample
    self.price = price
    self.originalPrice = originalPrice
    self.isSelected = isSelected
  }
  
  public static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
}
