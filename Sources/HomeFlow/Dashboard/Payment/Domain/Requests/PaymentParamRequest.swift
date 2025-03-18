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
  public let consultationGuideAnswerId: Int?
  public let voucherCode: String?
  public let paymentChannelCategory: String?

  public init(
    orderNumber: String,
    consultationGuideAnswerId: Int? = nil,
    voucherCode: String? = nil,
    paymentChannelCategory: String? = nil
  ) {
    self.orderNumber = orderNumber
    self.consultationGuideAnswerId = consultationGuideAnswerId
    self.voucherCode = voucherCode
    self.paymentChannelCategory = paymentChannelCategory
  }

  func toParam() -> [String : Any] {
    
    var parameters: [String : Any] = ["order_no" : orderNumber]
    
    if let consultationGuideAnswerId = consultationGuideAnswerId {
      parameters["consultation_guide_answer_id"] = consultationGuideAnswerId
    }
    
    if let voucherCode = voucherCode {
      parameters["voucher_code"] =  voucherCode
    }
    
    if let paymentChannelCategory = paymentChannelCategory {
      parameters["payment_channel_category"] = paymentChannelCategory
    }
    
    return parameters
    
  }
  
}
