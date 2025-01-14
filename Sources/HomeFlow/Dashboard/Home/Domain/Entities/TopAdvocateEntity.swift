//
//  TopAdvocateEntity.swift
//
//
//  Created by Ilham Prabawa on 26/07/24.
//

import Foundation
import AprodhitKit

public struct TopAdvocateEntity: Transformable, Equatable {

  typealias D = TopAdvocateResponseModel
  typealias E = TopAdvocateEntity
  typealias VM = TopAdvocateViewModel

  public private(set) var position: Int
  public private(set) var lawyerID: Int
  public private(set) var name: String
  public private(set) var image: String
  public private(set) var agency: String
  public private(set) var yearExp: Int

  public init() {
    self.position = 0
    self.lawyerID = 0
    self.name = ""
    self.image = ""
    self.agency = ""
    self.yearExp = 0
  }

  public init(
    position: Int,
    lawyerID: Int,
    name: String,
    image: String,
    agency: String,
    yearExp: Int
  ) {
    self.position = position
    self.lawyerID = lawyerID
    self.name = name
    self.image = image
    self.agency = agency
    self.yearExp = yearExp
  }

  static func map(from data: TopAdvocateResponseModel) -> TopAdvocateEntity {
    return TopAdvocateEntity(
      position: data.pos ?? 0,
      lawyerID: data.lawyerID ?? 0,
      name: data.name ?? "",
      image: data.image ?? "",
      agency: data.agency ?? "",
      yearExp: data.yearExp ?? 0
    )
  }

  static func mapTo(_ entity: TopAdvocateEntity) -> TopAdvocateViewModel {
    return TopAdvocateViewModel(
      position: entity.position,
      id: entity.lawyerID,
      image: entity.image,
      name: entity.name,
      agency: entity.agency,
      experience: entity.yearExp
    )
  }

  static func mapFrom(_ data: TopLawyerAgencyModel.Lawyer) -> TopAdvocateEntity {
    return TopAdvocateEntity(
      position: data.pos ?? 0,
      lawyerID: data.lawyerID ?? 0,
      name: data.name ?? "",
      image: data.image ?? "",
      agency: data.agency ?? "",
      yearExp: data.yearExp ?? 0
    )
  }

  static func mapFrom(_ data: TopLawyerAgencyModel.Agency) -> TopAgencyEntity {
    return TopAgencyEntity(
      position: data.pos ?? 0,
      name: data.agency ?? "",
      location: data.location ?? ""
    )
  }

}
