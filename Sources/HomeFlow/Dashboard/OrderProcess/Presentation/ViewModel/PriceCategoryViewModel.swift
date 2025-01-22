//
//  PriceCategoryViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/11/24.
//

import Foundation

public struct PriceCategoryViewModel: Identifiable {
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
  
}
