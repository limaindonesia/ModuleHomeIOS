//
//  VoucherViewModel.swift
//
//
//  Created by Ilham Prabawa on 28/10/24.
//

import Foundation

public class VoucherViewModel {

  public private(set) var success: Bool
  public private(set) var code: String
  public let amount: String
  public let tnc: String
  public let duration: Int

  public init() {
    self.success = false
    self.code = ""
    self.amount = ""
    self.tnc = ""
    self.duration = 0
  }

  public init(
    success: Bool,
    code: String,
    amount: String,
    tnc: String,
    duration: Int
  ) {
    self.success = success
    self.code = code
    self.amount = amount
    self.tnc = tnc
    self.duration = duration
  }

  public func setCode(_ code: String) {
    self.code = code
  }
  
}
