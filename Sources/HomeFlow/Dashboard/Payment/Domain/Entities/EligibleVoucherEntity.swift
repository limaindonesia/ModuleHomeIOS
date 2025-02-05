//
//  EligibleVoucherEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 03/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public final class EligibleVoucherEntity: TransformableWithoutViewModel, Identifiable {
  
  public typealias D = EligibleVoucherResponseModel.Datum
  public typealias E = EligibleVoucherEntity
  
  public var id = UUID()
  public let name: String
  public let code: String
  public let tnc: String
  public let expiredDate: Date
  public var isUsed: Bool
  
  public init() {
    self.name = ""
    self.code = ""
    self.tnc = ""
    self.expiredDate = Date()
    self.isUsed = false
  }
  
  public init(
    name: String,
    code: String,
    tnc: String,
    expiredDate: Date,
    isUsed: Bool
  ) {
    self.name = name
    self.code = code
    self.tnc = tnc
    self.expiredDate = expiredDate
    self.isUsed = isUsed
  }
  
  public static func map(from data: EligibleVoucherResponseModel.Datum) -> EligibleVoucherEntity {
    return EligibleVoucherEntity(
      name: data.name ?? "",
      code: data.code ?? "",
      tnc: data.tnc ?? "",
      expiredDate: (data.endDate ?? "").toDate() ?? Date(),
      isUsed: false
    )
  }
  
  public var dateStr: String {
    return "Belaku hingga: \(expiredDate.formatted(with: "dd MMMM yyyy"))"
  }
}
