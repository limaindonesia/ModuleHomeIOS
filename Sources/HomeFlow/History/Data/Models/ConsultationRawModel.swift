//
//  ConsultationModel.swift
//
//
//  Created by Ilham Prabawa on 03/07/23.
//

import Foundation

// MARK: - ConsultationModel
public struct ConsultationRawModel: Codable {
  public let success: Bool
  public let data: [ConsultationDataModel]
  public let message: String

  public init() {
    self.success = false
    self.data = []
    self.message = ""
  }

  public init(
    success: Bool,
    data: [ConsultationDataModel],
    message: String
  ) {

    self.success = success
    self.data = data
    self.message = message
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decode(Bool.self, forKey: .success)
    self.data = try container.decode([ConsultationDataModel].self, forKey: .data)
    self.message = try container.decode(String.self, forKey: .message)
  }

}

// MARK: - ConsultationDataModel
public struct ConsultationDataModel: Codable {
  public let id: Int?
  public let skill: Skill?
  public let serviceType: String?
  public let description, lawyerAttendance, clientAttendance, lawyerApprovedAt: String?
  public let stopTime, roomKey: String?
  public let status: String?
  public let summary: Summary?
  public let booking: Booking?
  public let totalPrice: Int?
  public let lastCall: String?
  public let client: Client?
  public let lawyer: Lawyer?
  public let roomExpiredAt, waitingExpiredAt, summarySentAt: String?
  public let lawyerIncome: String?
  public let is_audio_video_call_active: Bool?
  public let serviceTypeName: String?

  enum CodingKeys: String, CodingKey {
    case id, skill, description
    case lawyerAttendance = "lawyer_attendance"
    case serviceType = "service_type"
    case clientAttendance = "client_attendance"
    case lawyerApprovedAt = "lawyer_approved_at"
    case stopTime = "stop_time"
    case roomKey = "room_key"
    case status, summary, booking
    case totalPrice = "total_price"
    case lastCall = "last_call"
    case client, lawyer
    case roomExpiredAt = "room_expired_at"
    case waitingExpiredAt = "waiting_expired_at"
    case summarySentAt = "summary_sent_at"
    case lawyerIncome = "lawyer_income"
    case is_audio_video_call_active
    case serviceTypeName = "service_type_name"
  }

  public init() {
    self.id = 0
    self.skill = .init()
    self.serviceType = ""
    self.description = ""
    self.lawyerAttendance = ""
    self.clientAttendance = ""
    self.lawyerApprovedAt = ""
    self.stopTime = ""
    self.roomKey = ""
    self.status = ""
    self.summary = .init()
    self.booking = .init()
    self.totalPrice = 0
    self.lastCall = ""
    self.client = .init()
    self.lawyer = .init()
    self.roomExpiredAt = ""
    self.waitingExpiredAt = ""
    self.summarySentAt = ""
    self.lawyerIncome = ""
    self.is_audio_video_call_active = false
    self.serviceTypeName = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.skill = try container.decodeIfPresent(Skill.self, forKey: .skill)
    self.serviceType = try container.decodeIfPresent(String.self, forKey: .serviceType)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.lawyerAttendance = try container.decodeIfPresent(String.self, forKey: .lawyerAttendance)
    self.clientAttendance = try container.decodeIfPresent(String.self, forKey: .clientAttendance)
    self.lawyerApprovedAt = try container.decodeIfPresent(String.self, forKey: .lawyerApprovedAt)
    self.stopTime = try container.decodeIfPresent(String.self, forKey: .stopTime)
    self.roomKey = try container.decodeIfPresent(String.self, forKey: .roomKey)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.summary = try container.decodeIfPresent(Summary.self, forKey: .summary)
    self.booking = try container.decodeIfPresent(Booking.self, forKey: .booking)
    self.totalPrice = try container.decodeIfPresent(Int.self, forKey: .totalPrice)
    self.lastCall = try container.decodeIfPresent(String.self, forKey: .lastCall)
    self.client = try container.decodeIfPresent(Client.self, forKey: .client)
    self.lawyer = try container.decodeIfPresent(Lawyer.self, forKey: .lawyer)
    self.roomExpiredAt = try container.decodeIfPresent(String.self, forKey: .roomExpiredAt)
    self.waitingExpiredAt = try container.decodeIfPresent(String.self, forKey: .waitingExpiredAt)
    self.summarySentAt = try container.decodeIfPresent(String.self, forKey: .summarySentAt)
    self.lawyerIncome = try container.decodeIfPresent(String.self, forKey: .lawyerIncome)
    self.is_audio_video_call_active = try container.decodeIfPresent(Bool.self, forKey: .is_audio_video_call_active)
    self.serviceTypeName = try container.decodeIfPresent(String.self, forKey: .serviceTypeName)
  }

}

// MARK: - Booking
public struct Booking: Codable {
  public let id, parentID, consultationID, bookingableID: Int?
  public let bookingableType: String?
  public let bookingDate: String?
  public let bookingTime: String?
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

  public init() {
    self.id = 0
    self.parentID = 0
    self.consultationID = 0
    self.bookingableID = 0
    self.bookingableType = ""
    self.bookingDate = ""
    self.bookingTime = ""
    self.duration = 0
    self.status = 0
    self.createdAt = ""
    self.updatedAt = ""
  }

  public init(from decoder: Decoder) throws {
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

//  public init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.id = try container.decode(Int.self, forKey: .id)
//    self.parentID = try container.decode(Int.self, forKey: .parentID)
//    self.consultationID = try container.decode(Int.self, forKey: .consultationID)
//    self.bookingableID = try container.decode(Int.self, forKey: .bookingableID)
//    self.bookingableType = try container.decode(String.self, forKey: .bookingableType)
//    self.bookingDate = try container.decode(String.self, forKey: .bookingDate)
//    self.bookingTime = try container.decode(String.self, forKey: .bookingTime)
//    self.duration = try container.decode(Int.self, forKey: .duration)
//    self.status = try container.decode(Int.self, forKey: .status)
//    self.createdAt = try container.decode(String.self, forKey: .createdAt)
//    self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
//  }

}

// MARK: - Client
public struct Client: Codable {
  public let id: Int
  public let name: String?
  public let photoURL: String?
  public let birthDate: String?
  public let gender: String?
  public let address: Address?

  enum CodingKeys: String, CodingKey {
    case id, name
    case photoURL = "photo_url"
    case birthDate = "birth_date"
    case gender, address
  }

  public init() {
    self.id = 0
    self.name = ""
    self.photoURL = ""
    self.birthDate = ""
    self.gender = ""
    self.address = Address()
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
    self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
    self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
    self.address = try container.decodeIfPresent(Address.self, forKey: .address)
  }
  
}

// MARK: - Lawyer
public struct Lawyer: Codable {
  public let id: Int?
  public let name: String?
  public let price: String?
  public let photoURL: String?
  public let gender: String?
  public let city: Skill?
  public let yearExp: Int?
  public let avgRatings: String?
  public let avgRating: Int?
  public let slug: String?
  public let isOnline, isProbono: Bool?
  public let agencyName: String?
  public let agencyProvince: Skill?
  public let agencyCity: Skill?
  public let description: String?
  public let affidavitURL: String?
  public let ktpURL: String?
  public let address: String?
  public let educations: [Education]?
  public let skills: [Skill]?
  public let skillIDS: [Int]?

  enum CodingKeys: String, CodingKey {
    case id, name, price
    case photoURL = "photo_url"
    case gender, city
    case yearExp = "year_exp"
    case avgRating = "avg_rating"
    case avgRatings = "avg_ratings"
    case slug
    case isOnline = "is_online"
    case isProbono = "is_probono"
    case agencyName = "agency_name"
    case agencyProvince = "agency_province"
    case agencyCity = "agency_city"
    case description
    case affidavitURL = "affidavit_url"
    case ktpURL = "ktp_url"
    case address, educations, skills
    case skillIDS = "skill_ids"
  }

  public init() {
    self.id = 1
    self.name = ""
    self.price = ""
    self.photoURL = ""
    self.gender = ""
    self.city = .init()
    self.yearExp = 0
    self.avgRating = 0
    self.avgRatings = ""
    self.slug = ""
    self.isOnline = false
    self.isProbono = false
    self.agencyName = ""
    self.agencyProvince = .init()
    self.agencyCity = .init()
    self.description = ""
    self.affidavitURL = ""
    self.ktpURL = ""
    self.address = ""
    self.educations = []
    self.skills = []
    self.skillIDS = []
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.price = try container.decodeIfPresent(String.self, forKey: .price)
    self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
    self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
    self.city = try container.decodeIfPresent(Skill.self, forKey: .city)
    self.yearExp = try container.decodeIfPresent(Int.self, forKey: .yearExp)
    self.avgRating = try container.decodeIfPresent(Int.self, forKey: .avgRating)
    self.avgRatings = try container.decodeIfPresent(String.self, forKey: .avgRatings)
    self.slug = try container.decodeIfPresent(String.self, forKey: .slug)
    self.isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)
    self.isProbono = try container.decodeIfPresent(Bool.self, forKey: .isProbono)
    self.agencyName = try container.decodeIfPresent(String.self, forKey: .agencyName)
    self.agencyProvince = try container.decodeIfPresent(Skill.self, forKey: .agencyProvince)
    self.agencyCity = try container.decodeIfPresent(Skill.self, forKey: .agencyCity)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.affidavitURL = try container.decodeIfPresent(String.self, forKey: .affidavitURL)
    self.ktpURL = try container.decodeIfPresent(String.self, forKey: .ktpURL)
    self.address = try container.decodeIfPresent(String.self, forKey: .address)
    self.educations = try container.decodeIfPresent([Education].self, forKey: .educations)
    self.skills = try container.decodeIfPresent([Skill].self, forKey: .skills)
    self.skillIDS = try container.decodeIfPresent([Int].self, forKey: .skillIDS)
  }

}

// MARK: - Skill
public struct Skill: Codable {
  public let id: Int?
  public let name: String?

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
}

// MARK: - Education
public struct Education: Codable {
  public let institutionID: Int?
  public let institutionName: String?
  public let degree: String?

  enum CodingKeys: String, CodingKey {
    case institutionID = "institution_id"
    case institutionName = "institution_name"
    case degree
  }

  public init() {
    self.institutionID = 0
    self.institutionName = ""
    self.degree = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.institutionID = try container.decodeIfPresent(Int.self, forKey: .institutionID)
    self.institutionName = try container.decodeIfPresent(String.self, forKey: .institutionName)
    self.degree = try container.decodeIfPresent(String.self, forKey: .degree)
  }
}

// MARK: - Summary
public struct Summary: Codable {
  public let matter, legalBasis, analysis, conclusion, status: String?
  public let skill, subSkill: Skill?

  enum CodingKeys: String, CodingKey {
    case matter
    case legalBasis = "legal_basis"
    case analysis, conclusion
    case status
    case skill
    case subSkill = "skill_type"
  }

  public init() {
    self.matter = ""
    self.legalBasis = ""
    self.analysis = ""
    self.conclusion = ""
    self.status = ""
    self.skill = .init()
    self.subSkill = .init()
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.matter = try container.decodeIfPresent(String.self, forKey: .matter)
    self.legalBasis = try container.decodeIfPresent(String.self, forKey: .legalBasis)
    self.analysis = try container.decodeIfPresent(String.self, forKey: .analysis)
    self.conclusion = try container.decodeIfPresent(String.self, forKey: .conclusion)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.skill = try container.decodeIfPresent(Skill.self, forKey: .skill)
    self.subSkill = try container.decodeIfPresent(Skill.self, forKey: .subSkill)
  }
}

public struct Address: Codable {
  public init() {}
}

public struct AgencyProvince: Codable {
  public let id: Int?
  public let name: String?

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
}

public struct LawyerAgencyCity: Codable {
  public let id: Int?
  public let name: String?

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
}
