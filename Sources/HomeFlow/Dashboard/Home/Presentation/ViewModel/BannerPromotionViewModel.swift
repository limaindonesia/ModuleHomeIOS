//
//  BannerPromotionViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 31/10/24.
//

import Foundation

public class BannerPromotionViewModel {
  
  public let bannerImageURL: URL?
  public let popupImageURL: URL?
  
  public init() {
    self.bannerImageURL = nil
    self.popupImageURL = nil
  }
  
  public init(
    bannerImageURL: URL?,
    popupImageURL: URL?
  ) {
    self.bannerImageURL = bannerImageURL
    self.popupImageURL = popupImageURL
  }
  
}
