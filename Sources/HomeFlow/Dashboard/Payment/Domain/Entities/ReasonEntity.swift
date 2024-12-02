//
//  ReasonEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

import AprodhitKit

public class ReasonEntity: Equatable, Transformable {
  typealias D = ReasonResponseModel.Datum
  typealias E = ReasonEntity
  typealias VM = CancelReasonViewModel
  
  public let id: Int
  public var title: String
  public var selected: Bool = false
  
  public init() {
    self.id = 0
    self.title = ""
    self.selected = false
  }
  
  public init(
    id: Int,
    title: String,
    selected: Bool = false
  ) {
    self.id = id
    self.title = title
    self.selected = selected
  }
  
  public static func == (lhs: ReasonEntity, rhs: ReasonEntity) -> Bool {
    return lhs.id == rhs.id
  }
  
  public func toString() -> String {
    return "id: \(id), title: \(title), selected: \(selected)"
  }
  
  static func map(from data: ReasonResponseModel.Datum) -> ReasonEntity {
    return ReasonEntity(
      id: data.id ?? 0,
      title: data.reason ?? ""
    )
  }
  
  static func mapTo(_ entity: ReasonEntity) -> CancelReasonViewModel {
    return CancelReasonViewModel(
      id: entity.id,
      title: entity.title
    )
  }

}
