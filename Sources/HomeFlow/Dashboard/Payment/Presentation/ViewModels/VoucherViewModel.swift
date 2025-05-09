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
  public private(set) var amount: String
  public var tnc: String
  public var image_url: String
  public var duration: Int
  public var status: String
  public var quota: Int
  public var description: String

  public init() {
    self.success = false
    self.code = ""
    self.amount = ""
    self.tnc = ""
    self.image_url = ""
    self.duration = 0
    self.status = ""
    self.quota = 0
    self.description = ""
  }

  public init(
    success: Bool,
    code: String,
    amount: String,
    tnc: String,
    image_url: String,
    duration: Int,
    status: String,
    quota: Int,
    description: String
  ) {
    self.success = success
    self.code = code
    self.amount = amount
    self.tnc = tnc
    self.image_url = image_url
    self.duration = duration
    self.status = status
    self.quota = quota
    self.description = description
  }

  public func setCode(_ code: String) {
    self.code = code
  }
  
  public func setAmount(_ value: String) {
    self.amount = value
  }
}
