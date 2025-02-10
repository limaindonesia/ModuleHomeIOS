//
//  OrderNumberViewModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit

public class OrderViewModel {

  public let consultationID: Int
  public let expiredAt: Int
  public var lawyerFee: FeeViewModel
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
  
  public func expiredHours() -> String {
    let date = Double(expiredAt).epochToDate()
    return date.formatted(with: "HH:mm")
  }
  
  public func getTotalAdjustment() -> String {
    let total = CurrencyFormatter.toCurrency(NSNumber(value: totalAdjustmentPositive()))
    return total
  }
  
  public func totalAdjustmentPositive() -> Int {
    return totalAdjustment * -1
  }

}

public struct FeeViewModel: Identifiable {
  public var id: Int
  public let name: String
  public var amount: String
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
    let cleanedText = name.replacingOccurrences(of: "**", with: "")
    var attributedString = AttributedString(cleanedText)
    
    if let index = name.firstIndex(of: "*") {
      let result = name.suffix(from: index)
      let duration = result.replacingOccurrences(of: "**", with: "")
      if let found = cleanedText.range(of: duration) {
        let range = attributedString.range(of: cleanedText[found.lowerBound..<found.upperBound])!
        attributedString[range].font = .lexendFont(style: .title(size: 14))
      }
      
    }
    
    return attributedString
  }
  
  public func getPlainName() -> AttributedString {
    var text = name
    if let index = text.firstIndex(of: "*") {
      let suffix = text.suffix(from: index)
      let range = suffix.startIndex ..< suffix.endIndex
      text.removeSubrange(range)
    }
    return AttributedString()
  }
  
}
