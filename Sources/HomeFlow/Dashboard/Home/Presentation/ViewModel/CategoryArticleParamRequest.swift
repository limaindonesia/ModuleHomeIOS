//
//  CategoryArticleParamRequest.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public struct ArticleParamRequest: Paramable {
  public let name: String

  func toParam() -> [String : Any] {
    return ["category": name]
  }
}
