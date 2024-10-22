//
//  CategoryArticleResponseModel.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public struct CategoryArticleResponseModel: Codable {

  public let success: Bool?
  public let message: String?
  let data: [CategoryData]?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
    self.data = try container.decodeIfPresent([CategoryArticleResponseModel.CategoryData].self, forKey: .data)
  }

  public struct CategoryData: Codable {
    let termID: Int?
    let name, slug: String?
    let termGroup, termTaxonomyID: Int?
    let taxonomy: String?
    let description: String?
    let parent, count: Int?
    let filter: String?
    let catID, categoryCount: Int?
    let categoryDescription, catName, categoryNicename: String?
    let categoryParent: Int?

    enum CodingKeys: String, CodingKey {
      case termID = "term_id"
      case name, slug
      case termGroup = "term_group"
      case termTaxonomyID = "term_taxonomy_id"
      case taxonomy, description, parent, count, filter
      case catID = "cat_ID"
      case categoryCount = "category_count"
      case categoryDescription = "category_description"
      case catName = "cat_name"
      case categoryNicename = "category_nicename"
      case categoryParent = "category_parent"
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CategoryArticleResponseModel.CategoryData.CodingKeys> = try decoder.container(keyedBy: CategoryArticleResponseModel.CategoryData.CodingKeys.self)
      self.termID = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.termID)
      self.name = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.name)
      self.slug = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.slug)
      self.termGroup = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.termGroup)
      self.termTaxonomyID = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.termTaxonomyID)
      self.taxonomy = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.taxonomy)
      self.description = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.description)
      self.parent = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.parent)
      self.count = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.count)
      self.filter = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.filter)
      self.catID = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.catID)
      self.categoryCount = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.categoryCount)
      self.categoryDescription = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.categoryDescription)
      self.catName = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.catName)
      self.categoryNicename = try container.decodeIfPresent(String.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.categoryNicename)
      self.categoryParent = try container.decodeIfPresent(Int.self, forKey: CategoryArticleResponseModel.CategoryData.CodingKeys.categoryParent)
    }
  }

}

