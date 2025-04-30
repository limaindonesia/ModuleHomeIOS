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
  public let voucherAuto: VoucherEntity?
  public let legalForm: LegalFormEntity

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
    self.legalForm = .init()
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
    voucherAuto: VoucherEntity?,
    legalForm: LegalFormEntity
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
    self.legalForm = legalForm
  }

  static func map(from data: OrderResponseModel.DataClass) -> OrderEntity {
    var voucherEntity: FeeEntity? = nil
    var discountEntity: FeeEntity? = nil
    var voucherAutoEntity: VoucherEntity? = nil
    var documentFeeEntity: FeeEntity? = nil
    var adminFeeEntity: FeeEntity? = nil
    var legalFormEntity: LegalFormEntity? = nil
    
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
    
    if let voucher = data.voucher, voucher.code != nil {
      voucherAutoEntity = VoucherEntity(
        success: true,
        code: voucher.code ?? "",
        amount: voucher.amount ?? "",
        tnc: voucher.tnc ?? "",
        descriptions: voucher.description ?? "",
        duration: voucher.duration ?? 0,
        quota: 0
      )
    }
    
    if let fee = data.orderItems?.documentFee {
      documentFeeEntity = FeeEntity(
        name: fee.name ?? "",
        amount: fee.amount ?? ""
      )
    }
    
    if let fee = data.orderItems?.adminFee {
      adminFeeEntity = FeeEntity(
        name: fee.name ?? "",
        amount: fee.amount ?? ""
      )
    }
    
    if let legalForm = data.legalForm {
      legalFormEntity = LegalFormEntity(
        type: .COMPLETED,
        status: .DONE,
        title: legalForm.name ?? "",
        timeRemaining: 0.0,
        date: "",
        price: legalForm.price ?? "",
        rating: Int(legalForm.rating ?? "") ?? 0,
        legalFormID: legalForm.id ?? "",
        orderNumber: "",
        paymentURL: "",
        adminFee: adminFeeEntity ?? .init(),
        legalFormFee: documentFeeEntity ?? .init(),
        discount: discountEntity ?? .init(),
        totalAmount: legalForm.finalPrice ?? "",
        paymentMethod: "",
        paymentStatus: ""
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
      voucherAuto: voucherAutoEntity ?? .init(),
      legalForm: legalFormEntity ?? .init()
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
      documentFee: FeeViewModel(
        id: 1,
        name: entity.legalForm.legalFormFee.name,
        amount: entity.legalForm.legalFormFee.amount
      ),
      totalAmount: entity.total,
      totalAdjustment: entity.totalAdjustment
    )
  }

}
