//
//  ConsultationHistoryResponse.swift
//
//
//  Created by Ilham Prabawa on 29/08/23.
//

import Foundation
import GnDKit
import AprodhitKit

// MARK: - ConsultationHistory
public struct ConsultationHistoryResponse: Codable {
  let success: Bool?
  let data: ConsultationHistoryMetaData?
  let message: String?
}

// MARK: - DataClass
public struct ConsultationHistoryMetaData: Codable {
  let data: [UserCases]?
  let links: Links?
  let meta: Meta?
}

// MARK: - Datum
public struct ConsultationHistoryData: Codable {
  let id: Int?
  let skill: Skill?
  let serviceType: String?
  let serviceTypeName: String?
  let description, lawyerAttendance, clientAttendance, lawyerApprovedAt: String?
  let stopTime, roomKey: String?
  let status: String?
  let isClientRated: Bool?
  let booking: Booking?
  let totalPrice: Int?
  let lastCall: String?
  let client: Client?
  let lawyer: Lawyer?
  let summary: Summary?
  let roomExpiredAt, waitingExpiredAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id, skill, description
    case serviceType = "service_type"
    case serviceTypeName = "service_type_name"
    case lawyerAttendance = "lawyer_attendance"
    case clientAttendance = "client_attendance"
    case lawyerApprovedAt = "lawyer_approved_at"
    case stopTime = "stop_time"
    case roomKey = "room_key"
    case status
    case isClientRated = "is_client_rated"
    case booking
    case totalPrice = "total_price"
    case lastCall = "last_call"
    case client, lawyer, summary
    case roomExpiredAt = "room_expired_at"
    case waitingExpiredAt = "waiting_expired_at"
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.skill = try container.decodeIfPresent(Skill.self, forKey: .skill)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.serviceType = try container.decodeIfPresent(String.self, forKey: .serviceType)
    self.serviceTypeName = try container.decodeIfPresent(String.self, forKey: .serviceTypeName)
    self.lawyerAttendance = try container.decodeIfPresent(String.self, forKey: .lawyerAttendance)
    self.clientAttendance = try container.decodeIfPresent(String.self, forKey: .clientAttendance)
    self.lawyerApprovedAt = try container.decodeIfPresent(String.self, forKey: .lawyerApprovedAt)
    self.stopTime = try container.decodeIfPresent(String.self, forKey: .stopTime)
    self.roomKey = try container.decodeIfPresent(String.self, forKey: .roomKey)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.isClientRated = try container.decodeIfPresent(Bool.self, forKey: .isClientRated)
    self.booking = try container.decodeIfPresent(Booking.self, forKey: .booking)
    self.totalPrice = try container.decodeIfPresent(Int.self, forKey: .totalPrice)
    self.lastCall = try container.decodeIfPresent(String.self, forKey: .lastCall)
    self.client = try container.decodeIfPresent(Client.self, forKey: .client)
    self.lawyer = try container.decodeIfPresent(Lawyer.self, forKey: .lawyer)
    self.summary = try container.decodeIfPresent(Summary.self, forKey: .summary)
    self.roomExpiredAt = try container.decodeIfPresent(String.self, forKey: .roomExpiredAt)
    self.waitingExpiredAt = try container.decodeIfPresent(String.self, forKey: .waitingExpiredAt)
  }
  
  public func getType() -> ConsultationRowType {
    let dictionary = [
      Constant.Home.Text.WAITING_FOR_PAYMENT : ConsultationRowType.INCOMING,
      Constant.Home.Text.WAITING_FOR_APPROVAL : ConsultationRowType.INCOMING,
      Constant.Home.Text.ORDER_PENDING : ConsultationRowType.INCOMING,
      Constant.Home.Text.ON_PROCESS: ConsultationRowType.INCOMING,
      Constant.Home.Text.REJECTED : ConsultationRowType.HISTORY,
      Constant.Home.Text.CASE_DONE: ConsultationRowType.HISTORY
    ]
    
    return dictionary[status ?? ""] ?? .HISTORY
  }
  
  public func getStatus() -> ConsultationStatus {
    let dictionary = [
      Constant.Home.Text.CASE_DONE : ConsultationStatus.DONE,
      Constant.Home.Text.REJECTED : ConsultationStatus.REJECTED,
      Constant.Home.Text.ON_PROCESS : ConsultationStatus.ONGOING
    ]
    
    return dictionary[status ?? ""] ?? .REJECTED
  }
}

// MARK: - Links
//struct Links: Codable {
//  let first, last: String?
//  let prev: String?
//  let next: String?
//}

// MARK: - Meta
struct Meta: Codable {
  let currentPage, from, lastPage: Int?
  let links: [Link]?
  let path: String?
  let perPage, to, total: Int?
  
  enum CodingKeys: String, CodingKey {
    case currentPage = "current_page"
    case from
    case lastPage = "last_page"
    case links, path
    case perPage = "per_page"
    case to, total
  }
}

// MARK: - Link
struct Link: Codable {
  let url: String?
  let label: String?
  let active: Bool?
}
