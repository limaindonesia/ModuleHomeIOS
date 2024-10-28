//
//  VoucherParamRequest.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct VoucherParamRequest: Paramable {

  public let orderNumber: String
  public let voucherCode: String

  func toParam() -> [String : Any] {
    return [
      "order_no" : orderNumber,
      "voucher_code" : voucherCode
    ]
  }

}
