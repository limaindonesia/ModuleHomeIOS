//
//  ArticleViewModel.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public struct ArticleViewModel: Equatable, Identifiable {

  public let id: Int
  public let title: String
  private let imageURL: String
  public let content: String

  init() {
    self.id = 0
    self.title = ""
    self.imageURL = ""
    self.content = ""
  }

  public init(
    id: Int,
    title: String,
    imageURL: String,
    content: String
  ) {
    self.id = id
    self.title = title
    self.imageURL = imageURL
    self.content = content
  }

  public func getArticleImage() -> URL? {
    return URL(string: imageURL)
  }

}
