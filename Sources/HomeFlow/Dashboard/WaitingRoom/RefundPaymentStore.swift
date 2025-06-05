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
import FirebaseAnalytics

public class RefundPaymentStore {
  
  public let paymentCategory: PaymentCategory
  public let title: String
  public let userCase: UserCases
  public let tracker: AnalyticsManager
  
  public var navigateToForm = PassthroughSubject<Bool, Never>()
  public var gotoConsultationHistory = PassthroughSubject<Bool, Never>()
  
  public init(
    title: String,
    userCase: UserCases,
    paymentCategory: PaymentCategory,
    tracker: AnalyticsManager
  ) {
    self.title = title
    self.userCase = userCase
    self.paymentCategory = paymentCategory
    self.tracker = tracker
  }
  
  public func navigateTo() {
    if paymentCategory == .VA {
      navigateToForm.send(true)
      trackFormButton()
      return
    }
    
    gotoConsultationHistory.send(true)
    trackHistoryButton()
    
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
  
  func trackFormButton() {
    tracker.trackEvent(
      with: "fb_isi_form_button_waiting_room_page",
      parameters: [
        "timestap" : Date().formatted(with: "YYYY-MM-DD HH:mm:ss"),
        "platform" : "iOS"
      ]
    )
  }
  
  func trackHistoryButton() {
    tracker.trackEvent(
      with: "fb_lht_rwyt_knslts_btn_waiting_room_pg",
      parameters: [
        "timestap" : Date().formatted(with: "YYYY-MM-DD HH:mm:ss"),
        "platform" : "iOS"
      ]
    )
  }
  
}
