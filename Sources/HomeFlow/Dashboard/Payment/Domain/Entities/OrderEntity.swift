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
  public let discountFee: FeeEntity?
  public let voucher: FeeEntity?
  public let total: String
  public let totalAdjustment: Int
  public let expiredAt: Int
  public let voucherAuto: VoucherEntity

  init() {
    self.consultationID = 0
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discountFee = nil
    self.voucher = nil
    self.total = ""
    self.totalAdjustment = 0
    self.expiredAt = 0
    self.voucherAuto = .init()
  }

  public init(
    consultationID: Int,
    lawyerFee: FeeEntity,
    adminFee: FeeEntity,
    discountFee: FeeEntity?,
    voucher: FeeEntity?,
    total: String,
    totalAdjustment: Int,
    expiredAt: Int,
    voucherAuto: VoucherEntity
  ) {
    self.consultationID = consultationID
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discountFee = discountFee
    self.voucher = voucher
    self.total = total
    self.expiredAt = expiredAt
    self.totalAdjustment = totalAdjustment
    self.voucherAuto = voucherAuto
  }

  static func map(from data: OrderResponseModel.DataClass) -> OrderEntity {
    var voucherEntity: FeeEntity? = nil
    var discountEntity: FeeEntity? = nil
    
    let lawyerFee = data.orderItems?.lawyerFee
    let adminFee = data.orderItems?.adminFee

    if let voucher = data.orderItems?.voucher {
      voucherEntity = FeeEntity(
        name: voucher.name ?? "",
        amount: voucher.amount ?? ""
      )
    }
    
    if let discount = data.orderItems?.discount,
       discount.name != nil {
      
      discountEntity = FeeEntity(
        name: discount.name ?? "",
        amount: discount.amount ?? ""
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
      discountFee: discountEntity,
      voucher: voucherEntity,
      total: data.totalAmount ?? "",
      totalAdjustment: data.totalAdjustment ?? 0,
      expiredAt: data.expiredAt ?? 0,
      voucherAuto: VoucherEntity(
        success: true,
        code: data.voucher?.code ?? "",
        amount: data.voucher?.amount ?? "",
        tnc: data.voucher?.tnc ?? "",
        descriptions: data.voucher?.description ?? "",
        duration: data.voucher?.duration ?? 0
      )
    )
  }

  static func mapTo(_ entity: OrderEntity) -> OrderViewModel {
    var voucherViewModel: FeeViewModel? = nil
    var discountViewModel: FeeViewModel? = nil

    if let voucher = entity.voucher {
      voucherViewModel = FeeViewModel(
        id: 4,
        name: voucher.name,
        amount: voucher.amount
      )
    }
    
    if let discount = entity.discountFee {
      discountViewModel = FeeViewModel(
        id: 3,
        name: discount.name,
        amount: discount.amount
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
      discount: discountViewModel,
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
