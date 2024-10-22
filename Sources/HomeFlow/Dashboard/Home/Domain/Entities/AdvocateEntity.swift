//
//  AdvocateEntity.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import Foundation
import AprodhitKit

public struct AdvocateEntity: Transformable, Equatable {

  typealias D = Advocate
  typealias E = AdvocateEntity
  typealias VM = AdvocateViewModel

  public let id: Int
  public let name: String
  public let imageName: String
  public let experience: Int
  public let rating: String
  public let totalConsultation: Int
  public let price: Int
  public let originalPrice: String
  public let isDiscount: Bool

  public init() {
    self.id = 0
    self.name = ""
    self.imageName = ""
    self.experience = 0
    self.rating = ""
    self.totalConsultation = 0
    self.price = 0
    self.originalPrice = ""
    self.isDiscount = false
  }

  public init(
    id: Int,
    name: String,
    imageName: String,
    experience: Int,
    rating: String,
    totalConsultation: Int,
    price: Int,
    originalPrice: String,
    isDiscount: Bool
  ) {
    self.id = id
    self.name = name
    self.imageName = imageName
    self.experience = experience
    self.rating = rating
    self.totalConsultation = totalConsultation
    self.price = price
    self.originalPrice = originalPrice
    self.isDiscount = isDiscount
  }


  public static func mapTo(_ entity: AdvocateEntity) -> AdvocateViewModel {
    AdvocateViewModel(
      id: entity.id,
      name: entity.name,
      imageName: entity.imageName,
      experience: entity.experience,
      rating: entity.rating,
      totalConsultation: entity.totalConsultation,
      price: entity.price,
      originalPrice: entity.originalPrice,
      isDiscount: entity.isDiscount,
      isVoiceCallActive: false,
      isVideoCallActive: false,
      skills: []
    )
  }
  
  public static func map(from data: Advocate) -> AdvocateEntity {
    AdvocateEntity(
      id: data.id ?? 0,
      name: data.name ?? "",
      imageName: data.photo_url ?? "",
      experience: data.year_exp ?? 0,
      rating: data.avg_ratings ?? "",
      totalConsultation: data.total_consultations ?? 0,
      price: data.price ?? 0,
      originalPrice: data.prices?.original_price ?? "",
      isDiscount: data.prices?.is_discount ?? false
    )
  }

}
