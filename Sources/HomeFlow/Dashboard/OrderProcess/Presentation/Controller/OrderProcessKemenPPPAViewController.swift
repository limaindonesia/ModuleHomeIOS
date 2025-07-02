//
//  OrderProcessKemenPPPAViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 02/07/25.
//

import UIKit
import GnDKit
import AprodhitKit
import SwiftUI

public class OrderProcessKemenPPPAViewController: BaseViewController {
  
  private let store: OrderProcessKemenPPPAStore
  
  public init(
    advocate: Advocate,
    selectedPriceCategory: PriceCategoryViewModel,
    storeFactory: OrderProcessKemenPPPAStoreFactory
  ) {
    
    self.store = storeFactory.makeOrderProcessKemenPPPAStore(
      advocate: advocate,
      selectedPriceCategory: selectedPriceCategory
    )
    
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
    let rootView = UIHostingController(rootView: OrderProcessKemenPPPAView(store: store))
    addFullScreen(childViewController: rootView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    standardNavBar(title: "Proses Pesanan")

    view.backgroundColor = UIColor.gray050

    observeStore()

  }
  
  private func observeStore() {
    store.$error
      .dropFirst()
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { message in
        self.present(errorMessage: message)
      }.store(in: &subscriptions)
    
    store.$didBack
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state {
          self?.navigationController?.popToRootViewController(animated: false)
        }
      }.store(in: &subscriptions)
  }
  
  deinit {
    GLogger(
      .info,
      layer: "Presentation",
      message: String(
        describing: OrderProcessViewController.self
      )
    )
  }
  
}
