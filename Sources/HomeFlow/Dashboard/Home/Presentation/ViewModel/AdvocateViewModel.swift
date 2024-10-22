//
//  AdvocateViewModel.swift
//
//
//  Created by Ilham Prabawa on 18/07/24.
//

import Foundation
import AprodhitKit

public struct AdvocateViewModel: Equatable {

  public let id: Int
  public let name: String
  public let imageName: String
  public let experience: Int
  public let rating: String
  public let totalConsultation: Int
  public let price: Int
  public let originalPrice: String
  public let isDiscount: Bool
  public let isVoiceCallActive: Bool
  public let isVideoCallActive: Bool
  public let skills: [SkillViewModel]

  public init(
    id: Int,
    name: String,
    imageName: String,
    experience: Int,
    rating: String,
    totalConsultation: Int,
    price: Int,
    originalPrice: String,
    isDiscount: Bool,
    isVoiceCallActive: Bool,
    isVideoCallActive: Bool,
    skills: [SkillViewModel]
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
    self.isVoiceCallActive = isVoiceCallActive
    self.isVideoCallActive = isVideoCallActive
    self.skills = skills
  }

  public func getName() -> String {
    return name
  }

  public func getImageName() -> URL? {
    return URL(string: imageName)
  }

  public func getExperience() -> String {
    return "\(experience) tahun pengalaman"
  }

  public func getRating() -> String {
    return rating
  }

  public func getTotalConsultation() -> String {
    return "\(totalConsultation) Konsultasi"
  }

  public func getPrice() -> String {
    return "Rp \(price)"
  }

  public func getOriginalPrice() -> String {
    return "Rp \(originalPrice)"
  }

}
