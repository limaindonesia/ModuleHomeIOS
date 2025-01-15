//
//  OrderNumberResponseModel.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import GnDKit

// MARK: - OrderNumberResponseModel
public  struct OrderResponseModel: Codable {
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
    public let orderNo: String?
    public let totalPrice: Int?
    public let totalAmount: String?
    public let totalAdjustment: Int?
    public let status: String?
    public let consultations: [Consultation]?
    public let orderItems: OrderItems?
    public let orderAdjustments: [OrderAdjustment]?
    public let paymentMethods: [PaymentMethod]?
    public let expiredAt: Int?

    enum CodingKeys: String, CodingKey {
      case orderNo = "order_no"
      case totalPrice = "total_price"
      case totalAmount = "total_amount"
      case totalAdjustment = "total_adjustment"
      case status, consultations
      case orderItems = "order_items"
      case orderAdjustments = "order_adjustments"
      case paymentMethods = "payment_methods"
      case expiredAt = "expired_at"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.orderNo = try container.decodeIfPresent(String.self, forKey: .orderNo)
      self.totalPrice = try container.decodeIfPresent(Int.self, forKey: .totalPrice)
      self.totalAmount = try container.decodeIfPresent(String.self, forKey: .totalAmount)
      self.totalAdjustment = try container.decodeIfPresent(Int.self, forKey: .totalAdjustment)
      self.status = try container.decodeIfPresent(String.self, forKey: .status)
      self.consultations = try container.decodeIfPresent([Consultation].self, forKey: .consultations)
      self.orderItems = try container.decodeIfPresent(OrderItems.self, forKey: .orderItems)
      self.orderAdjustments = try container.decodeIfPresent([OrderAdjustment].self, forKey: .orderAdjustments)
      self.paymentMethods = try container.decodeIfPresent([PaymentMethod].self, forKey: .paymentMethods)
      self.expiredAt = try container.decodeIfPresent(Int.self, forKey: .expiredAt)
    }
  }

  // MARK: - Consultation
  public struct Consultation: Codable {
    public let id: Int?
    public let skill: Skill?
    public let description, lawyerAttendance, clientAttendance, lawyerApprovedAt: String?
    public let stopTime, roomKey, orderNo, status: String?
    public let isClientRated: Bool?
    public let booking: Booking?
    public let totalPrice: Int?
    public let lastCall: String?
    public let client: Client?
    public let lawyer: Lawyer?
    public let summary, lawyerRating: LawyerRating?
    public let summarySentAt, roomExpiredAt, waitingExpiredAt, recallExpiredAt: String?
    public let retries: Int?
    public let currentTime, paymentURL, paymentExpiredAt: String?
    public let payment, refund: LawyerRating?
    public let serviceType, lawyerIncome, autoCanceledAt: String?

    enum CodingKeys: String, CodingKey {
      case id, skill, description
      case lawyerAttendance = "lawyer_attendance"
      case clientAttendance = "client_attendance"
      case lawyerApprovedAt = "lawyer_approved_at"
      case stopTime = "stop_time"
      case roomKey = "room_key"
      case orderNo = "order_no"
      case status
      case isClientRated = "is_client_rated"
      case booking
      case totalPrice = "total_price"
      case lastCall = "last_call"
      case client, lawyer, summary
      case lawyerRating = "lawyer_rating"
      case summarySentAt = "summary_sent_at"
      case roomExpiredAt = "room_expired_at"
      case waitingExpiredAt = "waiting_expired_at"
      case recallExpiredAt = "recall_expired_at"
      case retries
      case currentTime = "current_time"
      case paymentURL = "payment_url"
      case paymentExpiredAt = "payment_expired_at"
      case payment, refund
      case serviceType = "service_type"
      case lawyerIncome = "lawyer_income"
      case autoCanceledAt = "auto_canceled_at"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.skill = try container.decodeIfPresent(Skill.self, forKey: .skill)
      self.description = try container.decodeIfPresent(String.self, forKey: .description)
      self.lawyerAttendance = try container.decodeIfPresent(String.self, forKey: .lawyerAttendance)
      self.clientAttendance = try container.decodeIfPresent(String.self, forKey: .clientAttendance)
      self.lawyerApprovedAt = try container.decodeIfPresent(String.self, forKey: .lawyerApprovedAt)
      self.stopTime = try container.decodeIfPresent(String.self, forKey: .stopTime)
      self.roomKey = try container.decodeIfPresent(String.self, forKey: .roomKey)
      self.orderNo = try container.decodeIfPresent(String.self, forKey: .orderNo)
      self.status = try container.decodeIfPresent(String.self, forKey: .status)
      self.isClientRated = try container.decodeIfPresent(Bool.self, forKey: .isClientRated)
      self.booking = try container.decodeIfPresent(Booking.self, forKey: .booking)
      self.totalPrice = try container.decodeIfPresent(Int.self, forKey: .totalPrice)
      self.lastCall = try container.decodeIfPresent(String.self, forKey: .lastCall)
      self.client = try container.decodeIfPresent(Client.self, forKey: .client)
      self.lawyer = try container.decodeIfPresent(Lawyer.self, forKey: .lawyer)
      self.summary = try container.decodeIfPresent(LawyerRating.self, forKey: .summary)
      self.lawyerRating = try container.decodeIfPresent(LawyerRating.self, forKey: .lawyerRating)
      self.summarySentAt = try container.decodeIfPresent(String.self, forKey: .summarySentAt)
      self.roomExpiredAt = try container.decodeIfPresent(String.self, forKey: .roomExpiredAt)
      self.waitingExpiredAt = try container.decodeIfPresent(String.self, forKey: .waitingExpiredAt)
      self.recallExpiredAt = try container.decodeIfPresent(String.self, forKey: .recallExpiredAt)
      self.retries = try container.decodeIfPresent(Int.self, forKey: .retries)
      self.currentTime = try container.decodeIfPresent(String.self, forKey: .currentTime)
      self.paymentURL = try container.decodeIfPresent(String.self, forKey: .paymentURL)
      self.paymentExpiredAt = try container.decodeIfPresent(String.self, forKey: .paymentExpiredAt)
      self.payment = try container.decodeIfPresent(LawyerRating.self, forKey: .payment)
      self.refund = try container.decodeIfPresent(LawyerRating.self, forKey: .refund)
      self.serviceType = try container.decodeIfPresent(String.self, forKey: .serviceType)
      self.lawyerIncome = try container.decodeIfPresent(String.self, forKey: .lawyerIncome)
      self.autoCanceledAt = try container.decodeIfPresent(String.self, forKey: .autoCanceledAt)
    }
  }

  // MARK: - Booking
  public struct Booking: Codable {
    public let id, parentID, consultationID, bookingableID: Int?
    public let bookingableType, bookingDate, bookingTime: String?
    public let duration, status: Int?
    public let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
      case id
      case parentID = "parent_id"
      case consultationID = "consultation_id"
      case bookingableID = "bookingable_id"
      case bookingableType = "bookingable_type"
      case bookingDate = "booking_date"
      case bookingTime = "booking_time"
      case duration, status
      case createdAt = "created_at"
      case updatedAt = "updated_at"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.parentID = try container.decodeIfPresent(Int.self, forKey: .parentID)
      self.consultationID = try container.decodeIfPresent(Int.self, forKey: .consultationID)
      self.bookingableID = try container.decodeIfPresent(Int.self, forKey: .bookingableID)
      self.bookingableType = try container.decodeIfPresent(String.self, forKey: .bookingableType)
      self.bookingDate = try container.decodeIfPresent(String.self, forKey: .bookingDate)
      self.bookingTime = try container.decodeIfPresent(String.self, forKey: .bookingTime)
      self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
      self.status = try container.decodeIfPresent(Int.self, forKey: .status)
      self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
      self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

  }

  // MARK: - Client
  public struct Client: Codable {
    public let id: Int?
    public let name, photoURL, birthDate, gender: String?
    public let address: Address?
    public let profileCompletions: ProfileCompletions?
    public let isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
      case id, name
      case photoURL = "photo_url"
      case birthDate = "birth_date"
      case gender, address
      case profileCompletions = "profile_completions"
      case isCompleted = "is_completed"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
      self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
      self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
      self.address = try container.decodeIfPresent(Address.self, forKey: .address)
      self.profileCompletions = try container.decodeIfPresent(ProfileCompletions.self, forKey: .profileCompletions)
      self.isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted)
    }
  }

  // MARK: - Address
  public struct Address: Codable {
    public let id: Int?
    public let address: String?
    public let cityID: Int?
    public let cityName: String?
    public let postalCodeID, status: Int?

    enum CodingKeys: String, CodingKey {
      case id, address
      case cityID = "city_id"
      case cityName = "city_name"
      case postalCodeID = "postal_code_id"
      case status
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.address = try container.decodeIfPresent(String.self, forKey: .address)
      self.cityID = try container.decodeIfPresent(Int.self, forKey: .cityID)
      self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
      self.postalCodeID = try container.decodeIfPresent(Int.self, forKey: .postalCodeID)
      self.status = try container.decodeIfPresent(Int.self, forKey: .status)
    }
  }

  // MARK: - ProfileCompletions
  public struct ProfileCompletions: Codable {
    public let validationPercentage: Int?
    public let validationMessage: String?
    public let sectionValidations: [JSONAny]?

    enum CodingKeys: String, CodingKey {
      case validationPercentage = "validation_percentage"
      case validationMessage = "validation_message"
      case sectionValidations = "section_validations"
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.validationPercentage = try container.decodeIfPresent(Int.self, forKey: .validationPercentage)
      self.validationMessage = try container.decodeIfPresent(String.self, forKey: .validationMessage)
      self.sectionValidations = try container.decodeIfPresent([JSONAny].self, forKey: .sectionValidations)
    }
  }

  // MARK: - Lawyer
  public struct Lawyer: Codable {
    public let id: Int?
    public let name: String?
    public let price: String?
    public let originalPrice: String?
    public let photoURL, gender: String?
    public let city: Skill?
    public let affidavitDate: String?
    public let yearExp: Int?
    public let avgRating: Double?
    public let avgRatings: String?
    public let totalConsultations: Int?
    public let slug: String?
    public let isOnline: Bool?
    public let agencyName: String?
    public let agencyProvince, agencyCity: Skill?
    public let description: String?
    public let isBusy, isVoiceCallActive, isVideoCallActive: Bool?
    public let educations: [JSONAny]?
    public let missedCallConsultation: LawyerRating?
    public let isAudioVideoCallActive: Bool?

    enum CodingKeys: String, CodingKey {
      case id, name, price
      case originalPrice = "original_price"
      case photoURL = "photo_url"
      case gender, city
      case affidavitDate = "affidavit_date"
      case yearExp = "year_exp"
      case avgRating = "avg_rating"
      case avgRatings = "avg_ratings"
      case totalConsultations = "total_consultations"
      case slug
      case isOnline = "is_online"
      case agencyName = "agency_name"
      case agencyProvince = "agency_province"
      case agencyCity = "agency_city"
      case description
      case isBusy = "is_busy"
      case isVoiceCallActive = "is_voice_call_active"
      case isVideoCallActive = "is_video_call_active"
      case educations
      case missedCallConsultation = "missed_call_consultation"
      case isAudioVideoCallActive = "is_audio_video_call_active"
    }
  }

  // MARK: - Skill
  public struct Skill: Codable {
    public let id: Int?
    public let name: String?
  }

  // MARK: - LawyerRating
  public struct LawyerRating: Codable {
  }

  // MARK: - Prices
  public struct Prices: Codable {
    public let isDiscount, isProbono: Bool?
    public let rangePrice, price, originalPrice: String?
    public let detail: [Detail]?

    enum CodingKeys: String, CodingKey {
      case isDiscount = "is_discount"
      case isProbono = "is_probono"
      case rangePrice = "range_price"
      case price
      case originalPrice = "original_price"
      case detail
    }
  }

  // MARK: - Detail
  public struct Detail: Codable {
    public let type, price, originalPrice: String?
    public let skills: [Skill]?

    enum CodingKeys: String, CodingKey {
      case type, price
      case originalPrice = "original_price"
      case skills
    }
  }

  public struct OrderAdjustment: Codable {
    public let name, amount: String?

    public init(name: String?, amount: String?) {
      self.name = name
      self.amount = amount
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<OrderResponseModel.OrderAdjustment.CodingKeys> = try decoder.container(keyedBy: OrderResponseModel.OrderAdjustment.CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: OrderResponseModel.OrderAdjustment.CodingKeys.name)
      self.amount = try container.decodeIfPresent(String.self, forKey: OrderResponseModel.OrderAdjustment.CodingKeys.amount)
    }
  }

  // MARK: - OrderItems
  public struct OrderItems: Codable {
    public let adminFee: AdminFee?
    public let lawyerFee: AdminFee?
    public let discount: AdminFee?
    public let voucher: AdminFee?

    enum CodingKeys: String, CodingKey {
      case adminFee = "admin_fee"
      case lawyerFee = "lawyer_fee"
      case discount
      case voucher
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.adminFee = try container.decodeIfPresent(AdminFee.self, forKey: .adminFee)
      self.lawyerFee = try container.decodeIfPresent(AdminFee.self, forKey: .lawyerFee)
      self.discount = try container.decodeIfPresent(AdminFee.self, forKey: .discount)
      self.voucher = try container.decodeIfPresent(AdminFee.self, forKey: .voucher)
    }
  }

  // MARK: - AdminFee
  public struct AdminFee: Codable {
    public let name, amount: String?

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.amount = try container.decodeIfPresent(String.self, forKey: .amount)
    }
  }
  
  // MARK: - PaymentMethod
  public struct PaymentMethod: Codable {
    public let name: String?
    public let icon: String?

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name)
      self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
  }

}
