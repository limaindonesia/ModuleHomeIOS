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
  public let image_url: String
  public let duration: Int
  public let quota: Int
  public let status: String

  public init() {
    self.success = false
    self.code = ""
    self.tnc = ""
    self.descriptions = ""
    self.amount = ""
    self.image_url = ""
    self.duration = 0
    self.quota = 0
    self.status = ""
  }

  public init(
    success: Bool,
    code: String,
    amount: String,
    tnc: String,
    descriptions: String,
    image_url: String,
    duration: Int,
    quota: Int,
    status: String
  ) {
    self.success = success
    self.code = code
    self.amount = amount
    self.tnc = tnc
    self.descriptions = descriptions
    self.image_url = image_url
    self.duration = duration
    self.quota = quota
    self.status = status
  }

  static func map(from response: VoucherResponseModel) -> VoucherEntity {
    return VoucherEntity(
      success: response.success ?? false,
      code: response.data?.code ?? "",
      amount: response.data?.amount ?? "",
      tnc: response.data?.tnc ?? "",
      descriptions: response.data?.description ?? "",
      image_url: response.data?.image_url ?? "",
      duration: response.data?.duration ?? 0,
      quota: response.data?.quota ?? 0,
      status: response.data?.status ?? ""
    )

  }

  static func mapTo(_ entity: VoucherEntity) -> VoucherViewModel {
    return VoucherViewModel(
      success: entity.success,
      code: entity.code,
      amount: entity.amount,
      tnc: entity.tnc,
      image_url: entity.image_url,
      duration: entity.duration,
      status: entity.status,
      quota: entity.quota,
      description: entity.descriptions
    )
  }

}
