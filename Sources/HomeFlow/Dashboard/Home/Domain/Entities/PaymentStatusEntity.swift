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
  private let status: String
  
  public init() {
    self.paymentURL = ""
    self.roomKey = ""
    self.status = ""
  }
  
  public init(
    paymentURL: String,
    roomKey: String,
    status: String
  ) {
    self.paymentURL = paymentURL
    self.roomKey = roomKey
    self.status = status
  }
  
  static func map(from data: PaymentStatusModelData) -> PaymentStatusEntity {
    return PaymentStatusEntity(
      paymentURL: data.payment_url ?? "",
      roomKey: data.room_key ?? "",
      status: data.status ?? ""
    )
  }
  
  static func mapTo(_ entity: PaymentStatusEntity) -> PaymentStatusViewModel {
    return PaymentStatusViewModel(
      paymentURL: entity.paymentURL,
      roomKey: entity.paymentURL,
      status: entity.status
    )
  }
  
}
