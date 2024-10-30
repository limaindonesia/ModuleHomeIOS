//
//  UseVoucerEntity.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public struct VoucherEntity: Transformable {

  typealias D = VoucherResponseModel

  typealias E = VoucherEntity

  typealias VM = VoucherViewModel

  public let success: Bool
  public let code: String
  public let amount: String
  public let tnc: String
  public let descriptions: String
  public let duration: Int

  public init() {
    self.success = false
    self.code = ""
    self.tnc = ""
    self.descriptions = ""
    self.amount = ""
    self.duration = 0
  }

  public init(
    success: Bool,
    code: String,
    amount: String,
    tnc: String,
    descriptions: String,
    duration: Int
  ) {
    self.success = success
    self.code = code
    self.amount = amount
    self.tnc = tnc
    self.descriptions = descriptions
    self.duration = duration
  }

  static func map(from response: VoucherResponseModel) -> VoucherEntity {
    return VoucherEntity(
      success: response.success ?? false,
      code: response.data?.code ?? "",
      amount: response.data?.amount ?? "",
      tnc: response.data?.tnc ?? "",
      descriptions: response.data?.description ?? "",
      duration: response.data?.duration ?? 0
    )

  }

  static func mapTo(_ entity: VoucherEntity) -> VoucherViewModel {
    return VoucherViewModel(
      success: entity.success,
      code: entity.code,
      amount: entity.amount,
      tnc: entity.tnc,
      duration: entity.duration
    )
  }

}
