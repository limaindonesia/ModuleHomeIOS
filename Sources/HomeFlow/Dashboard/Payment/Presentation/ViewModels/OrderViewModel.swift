//
//  OrderNumberViewModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation

public class OrderViewModel {

  public let consultationID: Int
  public let expiredAt: Int
  public let lawyerFee: FeeViewModel
  public let adminFee: FeeViewModel
  public let discount: FeeViewModel?
  public let voucher: FeeViewModel?
  public let totalAmount: String
  public let totalAdjustment: Int

  public init() {
    self.consultationID = 0
    self.expiredAt = 0
    self.lawyerFee = .init()
    self.adminFee = .init()
    self.discount = nil
    self.voucher = nil
    self.totalAmount = ""
    self.totalAdjustment = 0
  }

  public init(
    consultationID: Int,
    expiredAt: Int,
    lawyerFee: FeeViewModel,
    adminFee: FeeViewModel,
    discount: FeeViewModel?,
    voucher: FeeViewModel?,
    totalAmount: String,
    totalAdjustment: Int
  ) {
    self.consultationID = consultationID
    self.expiredAt = expiredAt
    self.lawyerFee = lawyerFee
    self.adminFee = adminFee
    self.discount = discount
    self.voucher = voucher
    self.totalAmount = totalAmount
    self.totalAdjustment = totalAdjustment
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
  private let name: String
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
  
  public func getName() -> AttributedString {
    var attributedString = AttributedString(name)
    attributedString.font = .lexendFont(style: .body(size: 14))
    attributedString.foregroundColor = .darkTextColor
    
    if let index = name.firstIndex(of: "*") {
      let boldedText = name.suffix(from: index)
      if let range = attributedString.range(of: boldedText)  {
        attributedString[range].font = .lexendFont(style: .title(size: 14))
      }
    }
    
    return attributedString
  }
}
