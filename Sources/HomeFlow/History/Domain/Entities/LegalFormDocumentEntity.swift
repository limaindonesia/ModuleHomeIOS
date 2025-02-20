//
//  LegalFormDocumentEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//

import Foundation
import GnDKit
import AprodhitKit

public struct LegalFormDocumentEntity: TransformableWithoutViewModel {
  
  public typealias D = String
  public typealias E = LegalFormDocumentEntity
  
  public let type: String
  public let status: String
  public let title: String
  public let timeRemaining: TimeInterval
  public let date: String
  public let price: String
  
  public init(
    type: String,
    status: String,
    title: String,
    timeRemaining: TimeInterval,
    date: String,
    price: String
  ) {
    self.type = type
    self.status = status
    self.title = title
    self.timeRemaining = timeRemaining
    self.date = date
    self.price = price
  }
  
  public static func map(from data: String) -> LegalFormDocumentEntity {
    fatalError()
  }
  
}
