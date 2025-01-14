//
//  TopAgencyEntity.swift
//
//
//  Created by Ilham Prabawa on 30/07/24.
//

import Foundation
import AprodhitKit

public struct TopAgencyEntity: Transformable, Equatable{

  typealias D = TopLawyerAgencyModel.Agency

  typealias E = TopAgencyEntity

  typealias VM = TopAgencyViewModel

  let position: Int
  let name: String
  let location: String

  public init() {
    self.position = 0
    self.name = ""
    self.location = ""
  }

  public init(
    position: Int,
    name: String,
    location: String
  ) {
    self.position = position
    self.name = name
    self.location = location
  }

  static func map(from data: TopLawyerAgencyModel.Agency) -> TopAgencyEntity {
    return TopAgencyEntity(
      position: data.pos ?? 0,
      name: data.agency ?? "-",
      location: data.location ?? "-"
    )
  }

  static func mapTo(_ entity: TopAgencyEntity) -> TopAgencyViewModel {
    return TopAgencyViewModel(
      position: entity.position,
      name: entity.name,
      location: entity.location
    )
  }

}
