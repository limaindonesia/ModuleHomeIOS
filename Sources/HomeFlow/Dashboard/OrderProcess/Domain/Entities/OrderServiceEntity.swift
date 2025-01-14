//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 13/01/25.
//


import Foundation

public struct OrderServiceEntity: Transformable {
  typealias D = OrderServiceItemData
  typealias E = OrderServiceEntity
  typealias VM = OrderServiceViewModel

  public let name: String
  public let type: String
  public let status: String // ACTIVE | INACTIVE
  public let duration: Int
  public let price: Int
  public let original_price: Int
  public let icon_url: String

  static func mapTo(_ entity: OrderServiceEntity) -> OrderServiceViewModel {
    return OrderServiceViewModel(name: entity.name,
                                 type: entity.type,
                                 status: entity.status,
                                 duration: entity.duration,
                                 price: entity.price,
                                 original_price: entity.original_price,
                                 icon_url: entity.icon_url)
  }

  static func map(from data: OrderServiceItemData) -> OrderServiceEntity {
    return OrderServiceEntity(name: data.name ?? "",
                              type: data.type ?? "",
                              status: data.status ?? "",
                              duration: data.duration ?? 0,
                              price: data.price ?? 0,
                              original_price: data.original_price ?? 0,
                              icon_url: data.icon_url ?? "")
  }

}
