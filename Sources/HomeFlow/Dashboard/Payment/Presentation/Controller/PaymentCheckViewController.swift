//
//  PaymentCheckVieController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import AprodhitKit
import GnDKit
import SwiftUI
import Combine

public class PaymentCheckViewController: NiblessViewController {
  
  private let store: PaymentCheckStore
  
  public var refundBottomSheetManager: DismissableActionBottomSheetManager!
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(store: PaymentCheckStore) {
    self.store = store
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public override func loadView() {
    super.loadView()
    
    let rootView = UIHostingController(rootView: PaymentCheckView(store: store))
    addFullScreen(childViewController: rootView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    standardNavBar(title: "Pembayaran")
    
    observeStore()
    
  }
  
  public override func didBack() {
    store.backToHome()
  }
  
  private func presentRefundBottomSheet() {
    
    let bottomStore = RefundPaymentSheetStore(
      paymentCategory: .EWALLET,
      title: "Konsultasi Kedaluarsa",
      price: "Rp75.000",
      buttonTitle: "",
      isFormRequired: false
    )
    
    let contentView = RefundBottomSheetView(store: bottomStore)
    
    let controller = RefundBottomSheetViewController()
      .setStore(bottomStore)
      .setContentView(contentView)
      .setUsedFixedHeight(with: screen.height / 2 - 16)
      .setDismissable(true)
    
    refundBottomSheetManager = DismissableActionBottomSheetManager(
      navigationController: navigationController,
      parentController: self
    )
    
    refundBottomSheetManager
      .setController(controller: controller)
      .show()
    
    refundBottomSheetManager.onDismissed = { [weak self] in
      guard let self = self else { return }
      refundBottomSheetManager = nil
    }
    
    bottomStore
      .navigateToForm
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        if state {
          self?.store.navigateToRefundForm()
          self?.releaseRefundBottomSheet()
        }
      }.store(in: &subscriptions)
    
    bottomStore
      .gotoConsultationHistory
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        self?.store.gotoHistoryConsultation()
        self?.releaseRefundBottomSheet()
      }.store(in: &subscriptions)
    
  }
  
  private func observeStore() {
    store.$showErrorMessage
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        if state {
          self.present(errorMessage: self.store.errorMessage)
        }
      }.store(in: &subscriptions)
    
    store.$isPresentRefundBottomSheet
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        if state {
          self.presentRefundBottomSheet()
        }
      }.store(in: &subscriptions)
  }
  
  private func releaseRefundBottomSheet() {
    guard let _ = refundBottomSheetManager else { return }
    refundBottomSheetManager.releaseBottomSheet()
    refundBottomSheetManager = nil
  }
  
}
