//
//  TreatmentEntity.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation

public struct TreatmentEntity: Transformable {

  typealias D = Session
  typealias E = TreatmentEntity
  typealias VM = TreatmentViewModel

  public let duration: Int
  public let type: String

  static func mapTo(_ entity: TreatmentEntity) -> TreatmentViewModel {
    return TreatmentViewModel(
      duration: entity.duration,
      type: entity.type
    )
  }

  static func map(from data: Session) -> TreatmentEntity {
    return TreatmentEntity(
      duration: data.duration ?? 0,
      type: data.name ?? ""
    )
  }

}
