//
//  TopDataEntity.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 04/10/24.
//

import Foundation
import AprodhitKit

public struct TopDataEntity {
  public let month: Int
  public let year: Int

  static func map(from data: TopLawyerAgencyModel.DataModel) -> TopDataEntity {
    return TopDataEntity(
      month: data.month ?? 0,
      year: data.year ?? 0
    )
  }

  public func getPeriode() -> String {
    let monthString: [Int : String] = [
      1 : "Januari",
      2 : "Februari",
      3 : "Maret",
      4 : "April",
      5 : "Mei",
      6 : "Juni",
      7 : "Juli",
      8 : "Agustus",
      9 : "September",
      10 : "Oktober",
      11 : "November",
      12 : "Desember"
    ]

    return monthString[month] ?? ""
  }

}
