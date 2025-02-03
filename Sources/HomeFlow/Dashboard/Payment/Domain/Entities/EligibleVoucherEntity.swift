//
//  EligibleVoucherEntity.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 03/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public struct EligibleVoucherEntity: TransformableWithoutViewModel, Identifiable {
  
  public typealias D = EligibleVoucherResponseModel.Datum
  public typealias E = EligibleVoucherEntity
  
  public var id = UUID()
  public let name: String
  public let code: String
  public let tnc: String
  public let expiredDate: Date
  
  public init(
    name: String,
    code: String,
    tnc: String,
    expiredDate: Date
  ) {
    self.name = name
    self.code = code
    self.tnc = tnc
    self.expiredDate = expiredDate
  }
  
  public static func map(from data: EligibleVoucherResponseModel.Datum) -> EligibleVoucherEntity {
    return EligibleVoucherEntity(
      name: "",
      code: "",
      tnc: "",
      expiredDate: Date()
    )
  }
  
  public var dateStr: String {
    return "Belaku hingga: \(expiredDate.formatted(with: "dd MMMM yyyy"))"
  }
}
