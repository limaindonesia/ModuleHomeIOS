//
//  PaymentViewController.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import GnDKit
import SwiftUI
import AprodhitKit
import Combine
import Lottie

public class PaymentViewController: NiblessViewController, SuccessViewDelegate {
  
  private let store: PaymentStore
  public var rejectionBottomSheetManager: DismissableActionBottomSheetManager!
  
  public var animationView: Lottie.LottieAnimationView?
  private var subscriptions = Set<AnyCancellable>()
  
  public init(store: PaymentStore) {
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
    
    let rootView = UIHostingController(rootView: PaymentView(store: store))
    addFullScreen(childViewController: rootView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    standardNavBar(title: "Pembayaran")
    
    observeStore()
  }
  
  private func loadAnimation() {
    animationView = .init(name: "lottie-loading")
    animationView!.backgroundColor = .clear
    animationView!.translatesAutoresizingMaskIntoConstraints = false
    animationView!.contentMode = .scaleAspectFit
    animationView!.loopMode = .loop
    animationView!.animationSpeed = 1
    view.addSubview(animationView!)
    
    NSLayoutConstraint.activate([
      animationView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      animationView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      animationView!.widthAnchor.constraint(equalToConstant: 180),
      animationView!.heightAnchor.constraint(equalToConstant: 180)
    ])
  }
  
  private func playAnimation() {
    loadAnimation()
    animationView?.play()
  }
  
  private func stopAnimation() {
    animationView?.isHidden = true
    animationView?.stop()
    animationView = nil
  }
  
  public override func didBack() {
    store.showWarningPaymentBottomSheet()
  }
  
  private func presentReasonSheet() {
    
    let bottomStore = RejectionBottomStore(
      arrayReasons: [
        .init(id: 1, title: "Ingin melihat advokat lain") ,
        .init(id: 2, title: "Bidang keahlian advokat tidak sesuai dengan permasalahan saya"),
        .init(id: 3, title: "Saya ingin mengganti deskripsi masalah"),
        .init(id: 4, title: "Biaya konsultasi kurang sesuai anggaran saya"),
        .init(id: 5, title: "Koneksi internet saya tidak stabil"),
        .init(id: 6, title: "Saya tidak menemukan metode pembayaran yang sesuai"),
        .init(id: 7, title: "Lainnya")
      ]
    )
    
    let contentView = RejectionBottomSheetRooView(store: bottomStore)
    contentView.onTapReject = { [weak self] value in
      self?.dismissRejectionSheet()
    }
    contentView.onTapCancel = { [weak self] in
      self?.dismissRejectionSheet()
    }
    contentView.delegate = self
    
    let rejectionController = RejectionReasonBottomViewController()
      .setStore(bottomStore)
      .setContentView(contentView)
      .setUsedFixedHeight(with: 600)
      .setDismissable(true)
    
    rejectionBottomSheetManager = DismissableActionBottomSheetManager(
      navigationController: navigationController,
      parentController: self
    )
    
    rejectionBottomSheetManager
      .setController(controller: rejectionController)
      .show()
    
    rejectionBottomSheetManager.onDismissed = { [weak self] in
      guard let self = self else { return }
      self.rejectionBottomSheetManager = nil
      self.hideTabbar(false)
    }
    
    hideTabbar(true)
  }
  
  private func dismissRejectionSheet() {
    guard let _ = rejectionBottomSheetManager else { return }
    
    rejectionBottomSheetManager.hide()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  private func hideTabbar(_ state: Bool) {
    self.tabBarController?.tabBar.isHidden = state
  }
  
  public func dismissAndBack() {
    
  }
  
  private func observeStore() {
    store.$isLoading
      .dropFirst()
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        if state {
          self.playAnimation()
        } else {
          self.stopAnimation()
        }
      }.store(in: &subscriptions)
    
    store.$isPresentReasonBottomSheet
      .dropFirst()
      .removeDuplicates()
      .filter{ $0 == true }
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { _ in
        self.presentReasonSheet()
      }.store(in: &subscriptions)
  }
  
  deinit {
    GLogger(
      .info,
      layer: "Presentation",
      message: String(
        describing: PaymentViewController.self
      )
    )
  }
}
