//
//  LawyerInfoViewModel.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation

public struct LawyerInfoViewModel {

  public let imageURL: URL?
  public let name: String
  public let agency: String
  public let price: String
  public let originalPrice: String
  public let isDiscount: Bool
  public let isProbono: Bool
  public var timeRemainig: TimeInterval

  public init() {
    self.imageURL = nil
    self.name = ""
    self.agency = ""
    self.price = ""
    self.originalPrice = ""
    self.isDiscount = false
    self.timeRemainig = 45
    self.isProbono = false
  }

  public init(
    imageURL: URL?,
    name: String,
    agency: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Bool,
    timeRemainig: TimeInterval
  ) {
    self.imageURL = imageURL
    self.name = name
    self.agency = agency
    self.price = price
    self.originalPrice = originalPrice
    self.isDiscount = isDiscount
    self.isProbono = isProbono
    self.timeRemainig = timeRemainig
  }

  public func getTimeRemaining() -> String {
    return timeRemainig.timeString()
  }

}
