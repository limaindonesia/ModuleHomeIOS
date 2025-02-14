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
  
  public func getHTMLText() -> String {
    return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <link rel="preconnect" href="https://fonts.googleapis.com">
              <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
              <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;700;800&display=swap" rel="stylesheet">
            <style>
                body {
                    font-family: 'Lexend', sans-serif;
                    font-size: 14px;
                    font-weight: 300;
                    line-height: 1.6;
                    marging: 0;
                    padding: 0;
                }
                ol {
                  display: block;
                  list-style-type: decimal;
                  margin-top: 1em;
                  margin-bottom: 1em;
                  margin-left: 0;
                  margin-right: 0;
                  padding-left: 20px;
                }
            </style>
        </head>
        <body>\(tnc)</body>
        </html>
      """
  }
  
}
