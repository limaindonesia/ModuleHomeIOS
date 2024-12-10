//
//  PaymentParamRequest.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct PaymentParamRequest: Paramable {

  public let orderNumber: String
  public let consultationGuideAnswerId: Int
  public let voucherCode: String
  public let paymentChannelCategory: String

  public init(
    orderNumber: String,
    consultationGuideAnswerId: Int,
    voucherCode: String,
    paymentChannelCategory: String
  ) {
    self.orderNumber = orderNumber
    self.consultationGuideAnswerId = consultationGuideAnswerId
    self.voucherCode = voucherCode
    self.paymentChannelCategory = paymentChannelCategory
  }

  func toParam() -> [String : Any] {
    return [
      "order_no" : orderNumber,
      "consultation_guide_answer_id" : consultationGuideAnswerId,
      "voucher_code" : voucherCode,
      "payment_channel_category" : paymentChannelCategory
    ]
  }
}
