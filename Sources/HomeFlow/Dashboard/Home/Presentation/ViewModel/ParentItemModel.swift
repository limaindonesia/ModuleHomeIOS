//
//  ParentItemModel.swift
//
//
//  Created by Ilham Prabawa on 27/10/23.
//

import Foundation


public enum SectionType {
  case active
  case category
}

public protocol ParentItemModel: Identifiable, Hashable {
  associatedtype T
  var id: Int { get set }
  var type: SectionType { get set }
  var onTap: (T) -> Void { get set }
}

extension ParentItemModel {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
