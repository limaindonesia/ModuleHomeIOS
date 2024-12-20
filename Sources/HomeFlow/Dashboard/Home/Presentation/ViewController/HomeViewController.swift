//
//  HomeViewController.swift
//
//
//  Created by Ilham Prabawa on 28/10/23.
//

import UIKit
import SwiftUI
import GnDKit
import AprodhitKit
import Combine

public class HomeViewController: NiblessViewController {
  
  private let storeFactory: HomeStoreFactory
  private var store: HomeStore!
  
  public var refundBottomSheetManager: DismissableActionBottomSheetManager!
  
  private var subscriptions = Set<AnyCancellable>()

  public init(storeFactory: HomeStoreFactory) {
    self.storeFactory = storeFactory
    store = storeFactory.makeHomeStore()
    super.init()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(true, animated: false)
    
    store.startSocket()
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    
    store.stopSocket()

  }

  public override func loadView() {
    super.loadView()

    let rootView = UIHostingController(rootView: HomeView(store: store))
    addFullScreen(childViewController: rootView)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    NLog(
      .info,
      layer: "Presentation",
      message: "currentVC \(String(describing: HomeViewController.self))"
    )

    view.backgroundColor = .white
    
    observeStore()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    view.frame = .init(
      x: 0,
      y: 0,
      width: screen.width,
      height: screen.height + 80
    )

  }

  func hideTabbar(_ state: Bool) {
    self.tabBarController?.tabBar.isHidden = state
  }
  
  private func presentRefundBottomSheet() {
    
    let bottomStore = RefundPaymentSheetStore(
      paymentCategory: store.meViewModel.paymentCategory,
      title: store.meViewModel.getTitlePopup(),
      price: store.meViewModel.price,
      buttonTitle: store.meViewModel.getButtonTitle(),
      isFormRequired: store.meViewModel.isFormRequired
    )
    
    let contentView = RefundBottomSheetView(store: bottomStore)
    
    let controller = RefundBottomSheetViewController()
      .setStore(bottomStore)
      .setContentView(contentView)
      .setUsedFixedHeight(with: screen.height / 2 - 16)
      .setDismissable(false)
    
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
      hideTabbar(false)
    }
    
    hideTabbar(true)
    
    bottomStore
      .navigateToForm
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        if state {
          self?.store.navigateToRefundForm()
          self?.releaseBottomSheet()
          self?.hideTabbar(false)
        }
      }.store(in: &subscriptions)
    
    bottomStore
      .gotoConsultationHistory
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        self?.store.gotoHistoryConsultation()
        self?.releaseBottomSheet()
        self?.hideTabbar(false)
      }.store(in: &subscriptions)
  }

  fileprivate func observeStore() {
    
    store.$isPresentRefundBottomSheet
      .receive(on: RunLoop.current)
      .subscribe(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        if state {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self?.presentRefundBottomSheet()
          }
        }
      }.store(in: &subscriptions)

    store.$hideTabBar
      .receive(on: RunLoop.current)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.hideTabbar(state)
      }.store(in: &subscriptions)

  }
  
  private func releaseBottomSheet() {
    guard let _ = refundBottomSheetManager else { return }
    refundBottomSheetManager.releaseBottomSheet()
    refundBottomSheetManager = nil
  }

}
