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
  }
  
}
