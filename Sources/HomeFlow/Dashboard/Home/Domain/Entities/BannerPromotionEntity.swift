//
//  BannerPromotionEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 31/10/24.
//

import Foundation

public struct BannerPromotionEntity: Transformable {
  
  typealias D = BannerResponseModel.DataClass
  
  typealias E = BannerPromotionEntity
  
  typealias VM = BannerPromotionViewModel
  
  
  public let bannerImageURL: String
  public let popupImageURL: String
  
  public init() {
    self.bannerImageURL = ""
    self.popupImageURL = ""
  }
  
  public init(bannerImageURL: String, popupImageURL: String) {
    self.bannerImageURL = bannerImageURL
    self.popupImageURL = popupImageURL
  }
  
  static func map(from data: BannerResponseModel.DataClass) -> BannerPromotionEntity {
    return BannerPromotionEntity(
      bannerImageURL: data.banner?[0].mobileImgURL ?? "",
      popupImageURL: data.popup?.mobileImgURL ?? ""
    )
  }
  
  static func mapTo(_ entity: BannerPromotionEntity) -> BannerPromotionViewModel {
    return BannerPromotionViewModel(
      bannerImageURL: URL(string: entity.bannerImageURL),
      popupImageURL: URL(string: entity.popupImageURL)
    )
  }
  
}
