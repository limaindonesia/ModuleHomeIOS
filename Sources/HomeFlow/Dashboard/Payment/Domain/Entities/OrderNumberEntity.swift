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

  public let lawyerFee: FeeEntity
  public let adminFee: FeeEntity
  public let discountFee: FeeEntity
  public let total: String
  public let expiredAt: Int

  init() {
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discountFee = .init()
    self.total = ""
    self.expiredAt = 0
  }

  public init(
    lawyerFee: FeeEntity,
    adminFee: FeeEntity,
    discountFee: FeeEntity,
    total: String,
    expiredAt: Int
  ) {
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discountFee = discountFee
    self.total = total
    self.expiredAt = expiredAt
  }

  static func map(from data: OrderNumberResponseModel.DataClass) -> OrderNumberEntity {
    let lawyerFee = data.orderItems?.lawyerFee
    let adminFee = data.orderItems?.adminFee
    let discountFee = data.orderItems?.discount

    return OrderNumberEntity(
      lawyerFee: FeeEntity(
        name: lawyerFee?.name ?? "",
        amount: lawyerFee?.amount ?? ""
      ),
      adminFee: FeeEntity(
        name: adminFee?.name ?? "",
        amount: adminFee?.amount ?? ""
      ),
      discountFee: FeeEntity(
        name: discountFee?.name ?? "",
        amount: discountFee?.amount ?? ""
      ),
      total: data.totalAmount ?? "",
      expiredAt: data.expiredAt ?? 0
    )
  }

  static func mapTo(_ entity: OrderNumberEntity) -> OrderNumberViewModel {
    return OrderNumberViewModel(
      expiredAt: entity.expiredAt,
      lawyerFee: entity.lawyerFee,
      adminFee: entity.adminFee,
      discount: entity.discountFee
    )
  }

}

public struct FeeEntity {
  public let name: String
  public let amount: String

  public init() {
    self.name = ""
    self.amount = ""
  }

  public init(name: String, amount: String) {
    self.name = name
    self.amount = amount
  }
}
