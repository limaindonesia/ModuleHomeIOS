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
  public let quota: Int
  public let status: String
  
  
  public init() {
    self.name = ""
    self.code = ""
    self.tnc = ""
    self.expiredDate = Date()
    self.isUsed = false
    self.quota = 0
    self.status = ""
  }
  
  public init(
    name: String,
    code: String,
    tnc: String,
    expiredDate: Date,
    isUsed: Bool,
    quota: Int,
    status: String
  ) {
    self.name = name
    self.code = code
    self.tnc = tnc
    self.expiredDate = expiredDate
    self.isUsed = isUsed
    self.quota = quota
    self.status = status
  }
  
  public static func map(from data: EligibleVoucherResponseModel.Datum) -> EligibleVoucherEntity {
    return EligibleVoucherEntity(
      name: data.name ?? "",
      code: data.code ?? "",
      tnc: data.tnc ?? "",
      expiredDate: (data.endDate ?? "").toDate() ?? Date(),
      isUsed: false,
      quota: data.quota ?? 0,
      status: data.status ?? ""
    )
  }
  
  public var dateStr: String {
    return "Berlaku hingga: \(expiredDate.formatted(with: "dd MMMM yyyy"))"
  }
  
  public func getHTMLText() -> String {
    return tnc.wrappedInHTML
  }
  
}
