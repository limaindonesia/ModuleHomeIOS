//
//  OrderNumberEntity.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public struct OrderNumberEntity: Transformable {

  typealias D = OrderNumberResponseModel.DataClass

  typealias E = OrderNumberEntity

  typealias VM = OrderNumberViewModel

  static func map(from data: OrderNumberResponseModel.DataClass) -> OrderNumberEntity {
    return OrderNumberEntity()
  }

  static func mapTo(_ entity: OrderNumberEntity) -> OrderNumberViewModel {
    return OrderNumberViewModel()
  }

}
