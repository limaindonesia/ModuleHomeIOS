//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import SwiftUI
import Combine
import Foundation
import GnDKit

public struct ListKemenPPPAViewModel: Codable, Hashable, Equatable {
  public var id: Int?
  public var name: String?
  public var is_discount: Bool?
  public var price: String?
  public var original_price: String?
  public var photo_url: String?
  public var gender: String?
  public var city: CityLawyersKemenPPPA?
  public var year_exp: Int?
  public var avg_ratings: String?
  public var total_consultations: Int?
  public var slug: String?
  public var is_online: Bool?
  public var agency_name: String?
  public var agency_province: AgencyProvinceKemenPPPA?
  public var agency_city: AgencyCityKemenPPPA?
  public var description: String?
  public var is_busy: Bool?
  public var educations: [EducationsAdvocateListKemenPPPA?] = []
  public var reviews: [ReviewsKemenPPPA] = []
  public var is_video_call_active: Bool?
  public var is_voice_call_active: Bool?
  public var is_audio_video_call_active: Bool?
  public var detail : [DetailPriceAdvocateKemenPPPA?] = []
  public var voucher_campaign : String = ""
  public var skill_type : String = ""
  

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
    self.is_discount = try container.decodeIfPresent(Bool?.self, forKey: .is_discount) ?? false
    self.price = try container.decodeIfPresent(String?.self, forKey: .price) ?? ""
    self.original_price = try container.decodeIfPresent(String?.self, forKey: .original_price) ?? ""
    self.photo_url = try container.decodeIfPresent(String?.self, forKey: .photo_url) ?? ""
    self.gender = try container.decodeIfPresent(String?.self, forKey: .gender) ?? ""
    self.city = try container.decodeIfPresent(CityLawyersKemenPPPA?.self, forKey: .city) as? CityLawyersKemenPPPA
    self.year_exp = try container.decodeIfPresent(Int?.self, forKey: .year_exp) ?? 0
    self.avg_ratings = try container.decodeIfPresent(String?.self, forKey: .avg_ratings) ?? "0.0"
    self.total_consultations = try container.decodeIfPresent(Int?.self, forKey: .total_consultations) ?? 0
    self.slug = try container.decodeIfPresent(String?.self, forKey: .slug) ?? ""
    self.is_online = try container.decodeIfPresent(Bool?.self, forKey: .is_online) ?? false
    self.is_busy = try container.decodeIfPresent(Bool?.self, forKey: .is_busy) ?? true
    self.agency_name = try container.decodeIfPresent(String?.self, forKey: .agency_name) ?? ""
    self.agency_province = try container.decodeIfPresent(AgencyProvinceKemenPPPA?.self, forKey: .agency_province) as? AgencyProvinceKemenPPPA
    self.agency_city = try container.decodeIfPresent(AgencyCityKemenPPPA?.self, forKey: .agency_city) as? AgencyCityKemenPPPA
    self.description = try container.decodeIfPresent(String?.self, forKey: .description) ?? ""
    self.educations = try (container.decodeIfPresent([EducationsAdvocateListKemenPPPA?]?.self, forKey: .educations) ?? []) ?? []
    self.reviews = try container.decodeIfPresent([ReviewsKemenPPPA].self, forKey: .reviews) ?? []
    self.is_video_call_active = try container.decodeIfPresent(Bool?.self, forKey: .is_video_call_active) as? Bool
    self.is_voice_call_active = try container.decodeIfPresent(Bool?.self, forKey: .is_voice_call_active) as? Bool
    self.is_audio_video_call_active = try container.decodeIfPresent(Bool?.self, forKey: .is_audio_video_call_active) as? Bool
    self.detail = try (container.decodeIfPresent([DetailPriceAdvocateKemenPPPA?]?.self, forKey: .detail) ?? []) ?? []
    self.voucher_campaign = try (container.decodeIfPresent(String?.self, forKey: .voucher_campaign) ?? "") ?? ""
    self.skill_type = try (container.decodeIfPresent(String?.self, forKey: .skill_type) ?? "") ?? ""
    
  }

  public init() {
    self.id = 0
    self.name = ""
    self.is_discount = false
    self.price = ""
    self.original_price = ""
    self.photo_url = ""
    self.gender = ""
    self.city = CityLawyersKemenPPPA()
    self.year_exp = 0
    self.avg_ratings = ""
    self.total_consultations = 0
    self.slug = ""
    self.is_online = false
    self.agency_name = ""
    self.agency_province = AgencyProvinceKemenPPPA()
    self.agency_city = AgencyCityKemenPPPA()
    self.description = ""
    self.is_busy = false
    self.educations = []
    self.reviews = []
    self.is_video_call_active = false
    self.is_voice_call_active = false
    self.is_audio_video_call_active = false
    self.detail = []
    self.voucher_campaign = ""
    self.skill_type = ""
  }

  public init(
    id: Int?,
    name: String?,
    is_discount: Bool?,
    price: String?,
    original_price: String?,
    photo_url: String?,
    gender: String?,
    city: CityLawyersKemenPPPA?,
    year_exp: Int?,
    avg_ratings: String?,
    total_consultations: Int?,
    slug: String?,
    is_online: Bool?,
    agency_name: String?,
    agency_province: AgencyProvinceKemenPPPA?,
    agency_city: AgencyCityKemenPPPA?,
    description: String?,
    is_busy: Bool?,
    educations: [EducationsAdvocateListKemenPPPA?],
    reviews: [ReviewsKemenPPPA],
    is_video_call_active: Bool?,
    is_voice_call_active: Bool?,
    is_audio_video_call_active: Bool?,
    detail: [DetailPriceAdvocateKemenPPPA?],
    voucher_campaign: String,
    skill_type: String
  ) {
    self.id = id
    self.name = name
    self.is_discount = is_discount
    self.price = price
    self.original_price = original_price
    self.photo_url = photo_url
    self.gender = gender
    self.city = city
    self.year_exp = year_exp
    self.avg_ratings = avg_ratings
    self.total_consultations = total_consultations
    self.slug = slug
    self.is_online = is_online
    self.agency_name = agency_name
    self.agency_province = agency_province
    self.agency_city = agency_city
    self.description = description
    self.is_busy = is_busy
    self.educations = educations
    self.reviews = reviews
    self.is_video_call_active = is_video_call_active
    self.is_voice_call_active = is_voice_call_active
    self.is_audio_video_call_active = is_audio_video_call_active
    self.detail = detail
    self.voucher_campaign = voucher_campaign
    self.skill_type = skill_type
  }

  public static func == (lhs: ListKemenPPPAViewModel, rhs: ListKemenPPPAViewModel) -> Bool {
    return lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public func getName() -> String {
    return name ?? ""
  }

  public func getImageName() -> URL? {
    return URL(string: photo_url ?? "")
  }

  public func getExperience() -> String {
    return "\(year_exp ?? 0) Tahun"
  }

  public func getRating() -> String {
    return avg_ratings ?? ""
  }

  public func getTotalConsultation() -> String {
    return "\(total_consultations ?? 0) Konsultasi"
  }
  

  public func getPrice() -> String {
    return price ?? ""
  }

  public func getOriginalPrice() -> String {
    return original_price ?? ""
  }
  
  public func getVoucherCampaign() -> String {
    return voucher_campaign
  }

  public var isDiscount: Bool {
    return is_discount ?? false
  }
  
  public func getLocation() -> String {
    var agencyName = agency_city?.name ?? ""
    let splitArray = agencyName.components(separatedBy: CharacterSet.whitespaces)
    if splitArray.count > 1 {
      let stringOne = splitArray[0]
      let stringTwo = splitArray[1]
      let agencyNameOne = stringOne.lowercased()
      let agencyNameTwo = stringTwo.lowercased()
      return agencyNameOne.prefix(1).uppercased() + agencyNameOne.dropFirst() + " " + agencyNameTwo.prefix(1).uppercased() + agencyNameTwo.dropFirst()
    } else {
      if agencyName != "" {
        agencyName = agencyName.lowercased()
        agencyName = agencyName.prefix(1).uppercased() + agencyName.dropFirst()
      }
      return agencyName
    }
  }
  
}

public struct DetailPriceAdvocateKemenPPPA: Codable {
  public var lawyer_skill_price_id : Int?
  public var skill_id : Int?
  public var name : String?
  public var case_example : String?
  public var price : String?
  public var original_price : String?
  public var skill_type : String?
  public var skills : [DetailSkillPriceAdvocateKemenPPPA?] = []
  
  public init() {
    self.price = ""
    self.original_price = ""
    self.skills = []
    self.skill_type = ""
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.lawyer_skill_price_id = try container.decodeIfPresent(Int?.self, forKey: .lawyer_skill_price_id) ?? 0
    self.skill_id = try container.decodeIfPresent(Int?.self, forKey: .skill_id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
    self.case_example = try container.decodeIfPresent(String?.self, forKey: .case_example) ?? ""
    self.price = try container.decodeIfPresent(String?.self, forKey: .price) ?? ""
    self.original_price = try container.decodeIfPresent(String?.self, forKey: .original_price) ?? ""
    self.skill_type = try container.decodeIfPresent(String?.self, forKey: .skill_type) ?? ""
  }
}

public struct DetailSkillPriceAdvocateKemenPPPA: Codable {
  public var id : Int?
  public var name : String?
  
  public init(id: Int?, name: String?) {
    self.id = id
    self.name = name
  }
  
  public init() {
    self.id = -1
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
  }
}

public struct CityLawyersKemenPPPA: Codable {
  public var id : Int?
  public var name : String?

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
  }
}

public struct AgencyProvinceKemenPPPA: Codable {
  public var id : Int?
  public var name : String?

  public init(){
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
  }
}

public struct AgencyCityKemenPPPA: Codable {
  public var id : Int?
  public var name : String?

  public init() {
    self.id = 0
    self.name = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? 0
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
  }
}

public struct EducationsAdvocateListKemenPPPA: Codable {
  public var institution_id : Int?
  public var institution_name : String?
  public var degree : String?

  public init(){
    self.institution_id = 0
    self.institution_name = ""
    self.degree = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.institution_id = try container.decodeIfPresent(Int?.self, forKey: .institution_id) ?? 0
    self.institution_name = try container.decodeIfPresent(String?.self, forKey: .institution_name) ?? ""
    self.degree = try container.decodeIfPresent(String?.self, forKey: .degree) ?? ""
  }
}

public struct ReviewsKemenPPPA: Codable {
  public var name : String?
  public var skill : String?
  public var rating : String?
  public var sent_at : String?
  public var description : String?

  public init() {
    self.name = ""
    self.skill = ""
    self.rating = ""
    self.sent_at = ""
    self.description = ""
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decodeIfPresent(String?.self, forKey: .name) ?? ""
    self.skill = try container.decodeIfPresent(String?.self, forKey: .skill) ?? ""
    self.rating = try container.decodeIfPresent(String?.self, forKey: .rating) ?? ""
    self.sent_at = try container.decodeIfPresent(String?.self, forKey: .sent_at) ?? ""
    self.description = try container.decodeIfPresent(String?.self, forKey: .sent_at) ?? ""
  }
}
