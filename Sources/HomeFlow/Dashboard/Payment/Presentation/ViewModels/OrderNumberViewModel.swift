//
//  OrderNumberViewModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public class OrderNumberViewModel {

  public let expiredAt: Int
  public let lawyerFee: FeeEntity
  public let adminFee: FeeEntity
  public let discount: FeeEntity

  public init() {
    self.expiredAt = 0
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discount = .init()
  }

  public init(
    expiredAt: Int,
    lawyerFee: FeeEntity,
    adminFee: FeeEntity,
    discount: FeeEntity
  ) {
    self.expiredAt = expiredAt
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discount = discount
  }

  public func getRemainingMinutes() -> TimeInterval {
    let interval = Double(expiredAt)
    let date = interval.epochToDate()
    let timeRemaining = Date().findMinutesDiff(with: date)
    return timeRemaining
  }

}
