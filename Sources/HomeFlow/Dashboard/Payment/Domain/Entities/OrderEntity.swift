//
//  OrderNumberEntity.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public struct OrderEntity: Transformable {

  typealias D = OrderResponseModel.DataClass

  typealias E = OrderEntity

  typealias VM = OrderViewModel

  public let consultationID: Int
  public let lawyerFee: FeeEntity
  public let adminFee: FeeEntity
  public let discountFee: FeeEntity
  public let voucher: FeeEntity?
  public let total: String
  public let totalAdjustment: Int
  public let expiredAt: Int

  init() {
    self.consultationID = 0
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discountFee = .init()
    self.voucher = nil
    self.total = ""
    self.totalAdjustment = 0
    self.expiredAt = 0
  }

  public init(
    consultationID: Int,
    lawyerFee: FeeEntity,
    adminFee: FeeEntity,
    discountFee: FeeEntity,
    voucher: FeeEntity?,
    total: String,
    totalAdjustment: Int,
    expiredAt: Int
  ) {
    self.consultationID = consultationID
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discountFee = discountFee
    self.voucher = voucher
    self.total = total
    self.expiredAt = expiredAt
    self.totalAdjustment = totalAdjustment
  }

  static func map(from data: OrderResponseModel.DataClass) -> OrderEntity {
    var voucherEntity: FeeEntity? = nil
    let lawyerFee = data.orderItems?.lawyerFee
    let adminFee = data.orderItems?.adminFee
    let discountFee = data.orderItems?.discount

    if let voucher = data.orderItems?.voucher {
      voucherEntity = FeeEntity(
        name: voucher.name ?? "",
        amount: voucher.amount ?? ""
      )
    }

    return OrderEntity(
      consultationID: data.consultations?[0].id ?? 0,
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
      voucher: voucherEntity,
      total: data.totalAmount ?? "",
      totalAdjustment: data.totalAdjustment ?? 0,
      expiredAt: data.expiredAt ?? 0
    )
  }

  static func mapTo(_ entity: OrderEntity) -> OrderViewModel {
    var voucherViewModel: FeeViewModel? = nil

    if let voucher = entity.voucher {
      voucherViewModel = FeeViewModel(
        id: 4,
        name: voucher.name,
        amount: voucher.amount
      )
    }

    return OrderViewModel(
      consultationID: entity.consultationID,
      expiredAt: entity.expiredAt,
      lawyerFee: FeeViewModel(
        id: 1,
        name: entity.lawyerFee.name,
        amount: entity.lawyerFee.amount
      ),
      adminFee: FeeViewModel(
        id: 2,
        name: entity.adminFee.name,
        amount: entity.adminFee.amount,
        showInfo: true
      ),
      discount: FeeViewModel(
        id: 3,
        name: entity.discountFee.name,
        amount: entity.discountFee.amount
      ),
      voucher: voucherViewModel,
      totalAmount: entity.total,
      totalAdjustment: entity.totalAdjustment
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
