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

public class PaymentViewController: NiblessViewController {
  
  private let store: PaymentStore
  
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
