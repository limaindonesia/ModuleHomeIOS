//
//  DocumentByIDEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import Foundation
import GnDKit

public class DocumentByIDEntity: TransformableWithoutViewModel {
  
  public typealias D = DocumentByIDResponseModel.DataClass
  public typealias E = DocumentByIDEntity
  
  public let id: String
  public let totalAmount: String
  public let paymentExpiredAt: String
  public let paymentMethod: String
  public let isClientRated: Bool
  public let rating: Int
  
  public init() {
    self.id = ""
    self.totalAmount = ""
    self.paymentExpiredAt = ""
    self.paymentMethod = ""
    self.isClientRated = false
    self.rating = 0
  }
  
  public init(
    id: String,
    totalAmount: String,
    paymentExpiredAt: String,
    paymentMethod: String,
    isClientRated: Bool,
    rating: Int
  ) {
    self.id = id
    self.totalAmount = totalAmount
    self.paymentExpiredAt = paymentExpiredAt
    self.paymentMethod = paymentMethod
    self.rating = rating
    self.isClientRated = isClientRated
  }
  
  public static func map(from data: DocumentByIDResponseModel.DataClass) -> DocumentByIDEntity {
    return .init()
  }
  
  public func getPaymentIcon() -> String {
    let dictionary = ["OVO" : "ic_payment_ovo",
                      "DANA" : "ic_payment_dana",
                      "SHOPEE" : "ic_payment_shopee"]
    
    return dictionary[paymentMethod] ?? ""
  }
  
}
