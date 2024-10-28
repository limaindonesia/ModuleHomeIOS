//
//  VoucherViewModel.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public class VoucherViewModel {

  public let code: String
  public let amount: String
  public let tnc: String
  public let duration: Int

  public init() {
    self.code = ""
    self.amount = ""
    self.tnc = ""
    self.duration = 0
  }

  public init(
    code: String,
    amount: String,
    tnc: String,
    duration: Int
  ) {
    self.code = code
    self.amount = amount
    self.tnc = tnc
    self.duration = duration
  }

}
