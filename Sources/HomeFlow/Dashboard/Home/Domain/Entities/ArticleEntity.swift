//
//  ArticleEntity.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public struct ArticleEntity: Transformable, Equatable {

  typealias D = ArticleResponseModel.ArticleData
  typealias E = ArticleEntity
  typealias VM = ArticleViewModel

  public let id: Int
  public let title: String
  public let author: String
  public let date: String
  public let content: String
  public let imageURL: String

  init() {
    self.id = 0
    self.imageURL = ""
    self.title = ""
    self.author = ""
    self.date = ""
    self.content = ""
  }

  public init(
    id: Int,
    imageURL: String,
    title: String,
    author: String,
    date: String,
    content: String
  ) {
    self.id = id
    self.imageURL = imageURL
    self.title = title
    self.author = author
    self.date = date
    self.content = content
  }

  static func mapTo(_ entity: ArticleEntity) -> ArticleViewModel {
    return ArticleViewModel(
      id: entity.id,
      title: entity.title,
      imageURL: entity.imageURL,
      content: entity.content
    )
  }

  static func map(from data: ArticleResponseModel.ArticleData) -> ArticleEntity {
    return ArticleEntity(
      id: data.post?.id ?? 0,
      imageURL: data.featuredImage ?? "",
      title: data.post?.postTitle ?? "",
      author: data.post?.postAuthor ?? "",
      date: data.post?.postDate ?? "",
      content: data.post?.postContent ?? ""
    )
  }

  static func map(from data: NewestArticleResponseModel) -> ArticleEntity {
    return ArticleEntity(
      id: data.id ?? 0,
      imageURL: data.featuredImage ?? "",
      title: data.title?.rendered ?? "",
      author: data.authorName ?? "",
      date: data.date ?? "",
      content: data.content?.rendered ?? ""
    )

  }

}
