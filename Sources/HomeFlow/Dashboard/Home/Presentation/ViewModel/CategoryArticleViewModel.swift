//
//  CategoryArticleViewModel.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

public class CategoryArticleViewModel: Identifiable {

  public let id: Int
  public let name: String
  public let niceName: String
  public private(set) var selected: Bool

  public init() {
    self.id = 0
    self.name = ""
    self.niceName = ""
    self.selected = false
  }

  public init(
    id: Int,
    name: String,
    niceName: String,
    selected: Bool = false
  ) {
    self.id = id
    self.name = name
    self.niceName = niceName
    self.selected = selected
  }

  public func setSelected(_ selected: Bool) {
    self.selected = selected
  }

}

extension CategoryArticleViewModel: Equatable {
  
  public static func == (
    lhs: CategoryArticleViewModel,
    rhs: CategoryArticleViewModel
  ) -> Bool {
    return lhs.id == rhs.id
  }

}
