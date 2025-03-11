//
//  HistoryPagerTabViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 07/03/25.
//

import Foundation
import GnDKit
import AprodhitKit

public typealias HistoryPagerTabNavigation = NavigationAction<HistoryPagerTabViewState>

public class HistoryPagerTabViewModel: LegalFormNavigator,
                                       BottomSheetResponder,
                                       PaymentNavigator,
                                       DashboardResponder {
  
  @Published public var navigationAction: LegalFormNavigation = .present(view: .main)
  @Published public var presentBottomSheet: Bool = false
  
  public func navigateToPayment(entity: LegalFormEntity) {
    navigationAction = .present(view: .payment(entity))
  }
  
  public func navigateToDetailOrder(entity: LegalFormEntity) {
    navigationAction = .present(view: .detail(entity))
  }
  
  public func navigateToDocumentDetail() {
    navigationAction = .present(view: .documentDetail)
  }
  
  public func navigateToCheckStatus(entity: LegalFormEntity) {
    navigationAction = .present(view: .checkStatus(entity))
  }
  
  public func navigateToPaymentCheck(
    entity: LegalFormEntity,
    paymentCategory: PaymentCategory
  ) {
    navigationAction = .present(view: .checkStatus(entity))
  }
  
  public func uiPresented(legalView: HistoryPagerTabViewState) {
    navigationAction = .presented(view: legalView)
  }
  
  public func showBottomSheet(_ show: Bool) {
    presentBottomSheet = show
  }
  
  public func navigateBack() {
    navigationAction = .present(view: .main)
  }
  
  public func navigateToPayment(_ parameter: LawyerInfoViewModel) {
    
  }
  
  public func navigateToPaymentCheck(
    lawyerInfo: LawyerInfoViewModel,
    price: String,
    roomkey: String,
    consultId: Int,
    urlPayment: String,
    orderID: String,
    paymentCategory: PaymentCategory
  ) {
    
  }
  
  public func navigateToPaymentGateway(_ url: URL?) {
    navigationAction = .present(view: .paymentGateway(url))
  }
  
  public func gotoDashboard() {
    
  }
  
}
