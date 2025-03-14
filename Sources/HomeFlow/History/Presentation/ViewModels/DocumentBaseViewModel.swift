//
//  DocumentBaseViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class DocumentBaseViewModel: Identifiable, Equatable, Hashable {
  
  public var id: UUID = UUID()
  public let type: DocumentRowType
  public let title: String
  
  public init() {
    self.title = ""
    self.type = .HISTORY
  }
  
  public init(
    type: DocumentRowType,
    title: String
  ) {
    self.title = title
    self.type = type
  }
  
  public static func == (lhs: DocumentBaseViewModel, rhs: DocumentBaseViewModel) -> Bool {
    return lhs.id == rhs.id && lhs.type == rhs.type
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
  
}
