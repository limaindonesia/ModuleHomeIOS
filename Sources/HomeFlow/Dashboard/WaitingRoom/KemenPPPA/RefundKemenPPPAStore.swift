//
//  RefundKemenPPPAStore.swift
//  HomeFlow
//
//  Created by Muhammad Yusuf on 10/12/24.
//

import Foundation
import AprodhitKit
import Combine
import UIKit
import FirebaseAnalytics

public class RefundKemenPPPAStore {
  
  public let title: String
  public let userCase: UserCases
  public let tracker: AnalyticsManager
  
  public var gotoConsultationHistory = PassthroughSubject<Bool, Never>()
  
  public init(
    title: String,
    userCase: UserCases,
    tracker: AnalyticsManager
  ) {
    self.title = title
    self.userCase = userCase
    self.tracker = tracker
  }
  
  public func navigateTo() {
    gotoConsultationHistory.send(true)
    trackHistoryButton()
    
  }
  
  public func buttonAttributedTitle() -> NSAttributedString {
    let attributedTitle = NSAttributedString(
      string: "Lihat Riwayat Konsultasi",
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
