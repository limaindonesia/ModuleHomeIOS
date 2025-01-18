//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 13/01/25.
//


import Foundation
import AprodhitKit

public struct OrderServiceEntity: Transformable {
  typealias D = OrderServiceItemData
  typealias E = OrderServiceEntity
  typealias VM = OrderServiceViewModel

  public let name: String
  public let type: String
  public let status: String // ACTIVE | INACTIVE
  public let duration: Int
  public let price: Int
  public let originalPrice: Int
  public let iconURL: String

  static func mapTo(_ entity: OrderServiceEntity) -> OrderServiceViewModel {
    return OrderServiceViewModel(
      id: 0,
      name: entity.name,
      type: entity.type,
      status: entity.status,
      duration: "\(entity.duration)",
      price: "\(entity.price)",
      originalPrice: "\(entity.originalPrice)",
      iconURL: entity.iconURL,
      isDiscount: false,
      isSKTM: false,
      isHaveQuotaSKTM: false,
      quotaSKTM: 0,
      isKTPActive: false,
      isSaving: false,
      isDisable: false,
      isSelected: false,
      descPrice: "",
      discountPrice: ""
    )
  }

  static func map(from data: OrderServiceItemData) -> OrderServiceEntity {
    return OrderServiceEntity(name: data.name ?? "",
                              type: data.type ?? "",
                              status: data.status ?? "",
                              duration: data.duration ?? 0,
                              price: data.price ?? 0,
                              originalPrice: data.original_price ?? 0,
                              iconURL: data.icon_url ?? "")
  }

  public func getImageURL() -> URL? {
    return URL(string: iconURL)
  }
  
  public func getDuration() -> String {
    return "\(duration) Menit"
  }
  
  public func getPrice() -> String {
    return CurrencyFormatter.toCurrency(NSNumber(value: price))
  }
  
  public func getOriginalPrice() -> String {
    return CurrencyFormatter.toCurrency(NSNumber(value: originalPrice))
  }
  
  public func getPricePerMinutes() -> String {
    let result = price/duration
    return "Setara \(result)/menit"
  }
  
  public func getProbonoStatus() -> String {
    return "KTP telah terverifikasi"
  }
  
}
