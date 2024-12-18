//
//  RefundConsultationStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/12/24.
//

import Foundation
import UIKit
import GnDKit
import AprodhitKit
import Combine

public class RefundPaymentSheetStore: SheetStore {
  
  public var navigateToForm = PassthroughSubject<Bool, Never>()
  public var gotoConsultationHistory = PassthroughSubject<Bool, Never>()
  
  let paymentCategory: PaymentCategory
  let title: String
  let price: String
  let buttonTitle: String
  let isFormRequired: Bool
  
  public init(
    paymentCategory: PaymentCategory,
    title: String,
    price: String,
    buttonTitle: String,
    isFormRequired: Bool
  ) {
    self.paymentCategory = paymentCategory
    self.title = title
    self.price = price
    self.buttonTitle = buttonTitle
    self.isFormRequired = isFormRequired
  }
  
  public required init() {
    self.paymentCategory = .EWALLET
    self.title = ""
    self.price = ""
    self.buttonTitle = ""
    self.isFormRequired = false
  }
  
  public func navigateTo() {
    if isFormRequired {
      navigateToForm.send(true)
      return
    }
    
    gotoConsultationHistory.send(true)
  }
  
  public func getSubTitle() -> String {
    if paymentCategory == .EWALLET || paymentCategory == .VA {
      return "Konsultasi ini dibatalkan, Perqara akan memulai prosedur Pengembalian Dana."
    }
    
    return "Proses pengembalian dana sebelumnya mengalami kendala teknis dan tidak berhasil."
  }
  
  public func getDescriptions() -> String {
    if paymentCategory == .VA {
      return "Dana akan dikembalikan sesuai detail tujuan yang Anda berikan."
    }
    return "Sistem akan secara otomatis memproses Pengembalian Dana dan mengembalikannya ke saldo E-Wallet Anda dalam waktu 3 x 24 jam (3 hari kerja)."
  }
  
  public func buttonAttributedTitle() -> NSAttributedString {
    let attributedTitle = NSAttributedString(
      string: buttonTitle,
      attributes: [
        .font: UIFont.lexendFont(style: .title(size: 14)),
        .foregroundColor: UIColor.white
      ]
    )
    
    return attributedTitle
  }
  
}
