//
//  CategoryArticleEntity.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public struct CategoryArticleEntity: Transformable, Equatable {

  typealias D = CategoryArticleResponseModel.CategoryData
  typealias E = CategoryArticleEntity
  typealias VM = CategoryArticleViewModel

  public let id: Int
  public let name: String
  public let niceName: String

  public init(id: Int) {
    self.id = id
    self.name = ""
    self.niceName = ""
  }

  public init(
    id: Int,
    name: String,
    niceName: String
  ) {
    self.id = id
    self.name = name
    self.niceName = niceName
  }

  static func mapTo(_ entity: CategoryArticleEntity) -> CategoryArticleViewModel {
    return CategoryArticleViewModel(
      id: entity.id,
      name: entity.name,
      niceName: entity.niceName
    )
  }

  static func map(from data: CategoryArticleResponseModel.CategoryData) -> CategoryArticleEntity {
    return CategoryArticleEntity(
      id: data.catID ?? 0,
      name: data.catName ?? "",
      niceName: data.categoryNicename ?? ""
    )
  }

}
