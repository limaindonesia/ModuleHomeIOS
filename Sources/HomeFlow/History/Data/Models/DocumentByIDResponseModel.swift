//
//  DocumentByIDResponseModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import Foundation
import AprodhitKit
import GnDKit

// MARK: - DocumentByIDResponseModel
public struct DocumentByIDResponseModel: Codable {
  public let success: Bool?
  public let data: DataClass?
  public let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  // MARK: - DataClass
  public struct DataClass: Codable {
    public let id: String?
    public let documentID: Int?
    public let orderNo: String?
    public let clientID: Int?
    public let legalFormID, status: String?
    public let isClientRated: Bool?
    public let documentRating: Int?
    public let generatedAt, createdAt: String?
    public let legalForm: [JSONAny]?
    public let payment: Payment?
    
    enum CodingKeys: String, CodingKey {
      case id
      case documentID = "document_id"
      case orderNo = "order_no"
      case clientID = "client_id"
      case legalFormID = "legal_form_id"
      case status
      case isClientRated = "is_client_rated"
      case documentRating = "document_rating"
      case generatedAt = "generated_at"
      case createdAt = "created_at"
      case legalForm = "legal_form"
      case payment
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(String.self, forKey: .id)
      self.documentID = try container.decodeIfPresent(Int.self, forKey: .documentID)
      self.orderNo = try container.decodeIfPresent(String.self, forKey: .orderNo)
      self.clientID = try container.decodeIfPresent(Int.self, forKey: .clientID)
      self.legalFormID = try container.decodeIfPresent(String.self, forKey: .legalFormID)
      self.status = try container.decodeIfPresent(String.self, forKey: .status)
      self.isClientRated = try container.decodeIfPresent(Bool.self, forKey: .isClientRated)
      self.documentRating = try container.decodeIfPresent(Int.self, forKey: .documentRating)
      self.generatedAt = try container.decodeIfPresent(String.self, forKey: .generatedAt)
      self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
      self.legalForm = try container.decodeIfPresent([JSONAny].self, forKey: .legalForm)
      self.payment = try container.decodeIfPresent(Payment.self, forKey: .payment)
    }
  }
  
  // MARK: - Payment
  public struct Payment: Codable {
    public let paymentURL: String?
    public let orderItems: OrderItems?
    public let totalAmount, paymentMethod, paymentStatus, paymentExpiredAt: String?
    
    enum CodingKeys: String, CodingKey {
      case paymentURL = "payment_url"
      case orderItems = "order_items"
      case totalAmount = "total_amount"
      case paymentMethod = "payment_method"
      case paymentStatus = "payment_status"
      case paymentExpiredAt = "payment_expired_at"
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.paymentURL = try container.decodeIfPresent(String.self, forKey: .paymentURL)
      self.orderItems = try container.decodeIfPresent(OrderItems.self, forKey: .orderItems)
      self.totalAmount = try container.decodeIfPresent(String.self, forKey: .totalAmount)
      self.paymentMethod = try container.decodeIfPresent(String.self, forKey: .paymentMethod)
      self.paymentStatus = try container.decodeIfPresent(String.self, forKey: .paymentStatus)
      self.paymentExpiredAt = try container.decodeIfPresent(String.self, forKey: .paymentExpiredAt)
    }
  }
  
  // MARK: - OrderItems
  public struct OrderItems: Codable {
    public let adminFee, legalFormFee: Fee?
    public let discount: Fee?
    
    enum CodingKeys: String, CodingKey {
      case adminFee = "admin_fee"
      case legalFormFee = "legal_form_fee"
      case discount
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.adminFee = try container.decodeIfPresent(Fee.self, forKey: .adminFee)
      self.legalFormFee = try container.decodeIfPresent(Fee.self, forKey: .legalFormFee)
      self.discount = try container.decodeIfPresent(Fee.self, forKey: .discount)
    }
  }
  
  // MARK: - Fee
  public struct Fee: Codable {
    public let name, amount: String?
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.amount = try container.decodeIfPresent(String.self, forKey: .amount)
    }
  }
}
