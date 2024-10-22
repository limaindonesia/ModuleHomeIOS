//
//  PaymentStatusEntity.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import Foundation

public struct PaymentStatusEntity: Transformable {

  typealias D = PaymentStatusModelData

  typealias E = PaymentStatusEntity

  typealias VM = PaymentStatusViewModel

  private let paymentURL: String
  private let roomKey: String

  static func map(from data: PaymentStatusModelData) -> PaymentStatusEntity {
    return PaymentStatusEntity(
      paymentURL: data.payment_url ?? "",
      roomKey: data.room_key ?? ""
    )
  }

  static func mapTo(_ entity: PaymentStatusEntity) -> PaymentStatusViewModel {
    return PaymentStatusViewModel(
      paymentURL: entity.paymentURL,
      roomKey: entity.paymentURL
    )
  }

}
