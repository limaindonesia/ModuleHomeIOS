//
//  LegalFormViewState.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/03/25.
//

import Foundation
import AprodhitKit

public enum HistoryPagerTabViewState {
  case main
  case detail(LegalFormEntity)
  case payment(LegalFormEntity)
  case checkStatus(LegalFormEntity)
  case documentDetail(URL?)
  case paymentGateway(URL?)
  case consultationHistory
  case consultationDetail
  case openURL(URL?)
  
  public func hidesNavigationBar() -> Bool {
    switch self {
    case .main:
      return true
    default:
      return false
    }
  }
}

extension HistoryPagerTabViewState: Equatable {
  
  public static func == (lhs: HistoryPagerTabViewState, rhs: HistoryPagerTabViewState) -> Bool {
    switch (lhs, rhs) {
    case (.main, .main),
      (.payment(_), .payment(_)),
      (.checkStatus, .checkStatus),
      (.documentDetail(_), .documentDetail(_)),
      (.detail(_), .detail(_)),
      (.paymentGateway(_), .paymentGateway(_)),
      (.consultationHistory, .consultationHistory),
      (.consultationDetail, .consultationDetail),
      (.openURL(_), .openURL(_)):
      return true
    default:
      return false
    }
  }
  
}
