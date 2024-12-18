//
//  RefundPaymentStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 10/12/24.
//

import Foundation
import AprodhitKit
import Combine
import UIKit

public class RefundPaymentStore {
  
  public let paymentCategory: PaymentCategory
  public let title: String
  public let userCase: UserCases
  
  public var navigateToForm = PassthroughSubject<Bool, Never>()
  public var gotoConsultationHistory = PassthroughSubject<Bool, Never>()
  
  public init(
    title: String,
    userCase: UserCases,
    paymentCategory: PaymentCategory
  ) {
    self.title = title
    self.userCase = userCase
    self.paymentCategory = paymentCategory
  }
  
  public func navigateTo() {
    if paymentCategory == .VA {
      navigateToForm.send(true)
      return
    }
    
    gotoConsultationHistory.send(true)
  }
  
  public func getDescriptions() -> String {
    if paymentCategory == .VA {
      return "Dana akan dikembalikan sesuai detail tujuan yang Anda berikan."
    }
    return "Sistem akan secara otomatis memproses Pengembalian Dana dan mengembalikannya ke saldo E-Wallet Anda dalam waktu 3 x 24 jam (3 hari kerja)."
  }
  
  public func buttonAttributedTitle() -> NSAttributedString {
    let attributedTitle = NSAttributedString(
      string: paymentCategory == .VA ? "Isi Form" : "Lihat Riwayat Konsultasi",
      attributes: [
        .font: UIFont.lexendFont(style: .title(size: 14)),
        .foregroundColor: UIColor.white
      ]
    )
    
    return attributedTitle
  }

}
