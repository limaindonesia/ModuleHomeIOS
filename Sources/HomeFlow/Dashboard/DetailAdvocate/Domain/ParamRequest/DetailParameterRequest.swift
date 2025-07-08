//
//  DetailParameterRequest.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/07/25.
//

import GnDKit

public struct DetailParameterRequest: Paramable {
  private let slug: String
  
  public init(slug: String) {
    self.slug = slug
  }
  
  public func toParam() -> [String : Any] {
    return ["slug" : slug]
  }
}
