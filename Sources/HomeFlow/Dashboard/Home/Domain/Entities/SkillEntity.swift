//
//  CategoryEntity.swift
//
//
//  Created by Ilham Prabawa on 24/07/24.
//

import Foundation
import AprodhitKit

public struct SkillEntity: Transformable, Equatable {

  typealias D = SkillResponseModel.SkillData
  typealias E = SkillEntity
  typealias VM = SkillViewModel

  private let id: Int
  private let iconName: String
  private let skillName: String
  private let type: String
  private let typeCount: Int

  public init() {
    self.id = 0
    self.iconName = ""
    self.skillName = ""
    self.type = ""
    self.typeCount = 0
  }

  public init(
    id: Int,
    skillName: String
  ) {
    self.id = id
    self.iconName = ""
    self.skillName = skillName
    self.type = ""
    self.typeCount = 0
  }

  public init(
    id: Int,
    iconName: String,
    skillName: String,
    type: String,
    typeCount: Int
  ) {
    self.id = id
    self.iconName = iconName
    self.skillName = skillName
    self.type = type
    self.typeCount = typeCount
  }

  public static func map(from response: SkillResponseModel.SkillData) -> SkillEntity {
    func getTypes() -> String {
      if let types = response.types,
         types.isEmpty {
        return ""
      }

      return response.types?[0].name ?? ""
    }

    return SkillEntity(
      id: response.id ?? 0,
      iconName: response.iconURL ?? "",
      skillName: response.name ?? "",
      type: getTypes(),
      typeCount: response.types?.count ?? 0
    )
  }

  public static func mapTo(_ entity: SkillEntity) -> SkillViewModel {
    return SkillViewModel(
      id: entity.id,
      iconName: entity.iconName,
      skillName: entity.skillName,
      type: entity.type,
      typeCount: entity.typeCount
    )
  }

}
