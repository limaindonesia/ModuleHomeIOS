//
//  ConsultationBaseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public enum ConsultationRowType {
  case INCOMING
  case HISTORY
}

public enum ConsultationStatus: String {
  case REJECTED = "Dibatalkan"
  case DONE = "Selesai"
  case ONGOING = "Berlangsung"
}

open class ConsultationBaseModel: Identifiable, Hashable {
  
  public var id: UUID = UUID()
  public var type: ConsultationRowType
  public let imageURL: URL?
  public let name: String
  
  public init() {
    self.name = ""
    self.imageURL = nil
    self.type = .HISTORY
  }
  
  public init(
    name: String,
    imageURL: URL?,
    type: ConsultationRowType
  ) {
    
    self.type = type
    self.imageURL = imageURL
    self.name = name
  }
  
  public static func == (lhs: ConsultationBaseModel, rhs: ConsultationBaseModel) -> Bool {
    return lhs.id == rhs.id && lhs.type == rhs.type
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
  
}
