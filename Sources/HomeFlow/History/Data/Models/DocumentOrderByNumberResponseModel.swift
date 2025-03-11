//
//  DocumentOrderByNumberResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 10/03/25.
//

import Foundation
import GnDKit
import AprodhitKit

// MARK: - DocumentOrderByNumberResponseModel
struct DocumentOrderByNumberResponseModel: Codable {
  let success: Bool?
  let data: DataClass?
  let message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
  let orderNo: String?
  let totalPrice: Int?
  let totalAmount: String?
  let totalAdjustment: Int?
  let status: String?
  let consultations: [JSONAny]?
  let legalForm: LegalForm?
  let orderItems: OrderItems?
  let orderAdjustments: [OrderAdjustment]?
  let paymentMethods: [PaymentMethod]?
  let voucher: Voucher?
  let expiredAt: Int?
  let orderType: String?
  
  enum CodingKeys: String, CodingKey {
    case orderNo
    case totalPrice
    case totalAmount
    case totalAdjustment
    case status, consultations
    case legalForm
    case orderItems
    case orderAdjustments
    case paymentMethods
    case voucher
    case expiredAt
    case orderType
  }
}

// MARK: - LegalForm
struct LegalForm: Codable {
  let id, categoryID, name, price: String?
  let finalPrice, description: String?
  let pictureURL: String?
  let category, rating: String?
  let totalCreated: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case categoryID
    case name, price
    case finalPrice
    case description
    case pictureURL
    case category, rating
    case totalCreated
  }
}


// MARK: - OrderAdjustment
struct OrderAdjustment: Codable {
  let name, amount: String?
}


// MARK: - OrderItems
struct OrderItems: Codable {
  let adminFee, documentFee, discount, voucher: OrderAdjustment?
  
  enum CodingKeys: String, CodingKey {
    case adminFee
    case documentFee
    case discount, voucher
  }
}


// MARK: - PaymentMethod
struct PaymentMethod: Codable {
  let name: String?
  let icon: String?
}


// MARK: - Voucher
struct Voucher: Codable {
  let code, amount, tnc, description: String?
  let duration: Int?
}
