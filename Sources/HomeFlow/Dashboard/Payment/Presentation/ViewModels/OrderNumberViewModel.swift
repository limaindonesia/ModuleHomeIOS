//
//  OrderNumberViewModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public class OrderNumberViewModel {

  public let expiredAt: Int
  public let lawyerFee: FeeViewModel
  public let adminFee: FeeViewModel
  public let discount: FeeViewModel
  public let totalAmount: String

  public init() {
    self.expiredAt = 0
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discount = .init()
    self.totalAmount = ""
  }

  public init(
    expiredAt: Int,
    lawyerFee: FeeViewModel,
    adminFee: FeeViewModel,
    discount: FeeViewModel,
    totalAmount: String
  ) {
    self.expiredAt = expiredAt
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discount = discount
    self.totalAmount = totalAmount
  }

  public func getRemainingMinutes() -> TimeInterval {
    let interval = Double(expiredAt)
    let date = interval.epochToDate()
    let timeRemaining = Date().findMinutesDiff(with: date)
    return timeRemaining
  }

  public func expiredDate() -> String {
    let date = Double(expiredAt).epochToDate()
    return date.formatted(with: "dd MMMM yyyy HH:mm")
  }

}

public struct FeeViewModel: Identifiable {
  public var id: Int
  public let name: String
  public let amount: String
  public let showInfo: Bool

  public init() {
    self.id = -1
    self.name = ""
    self.amount = ""
    self.showInfo = false
  }

  public init(
    id: Int,
    name: String,
    amount: String,
    showInfo: Bool = false
  ) {
    self.id = id
    self.name = name
    self.amount = amount
    self.showInfo = showInfo
  }
}
