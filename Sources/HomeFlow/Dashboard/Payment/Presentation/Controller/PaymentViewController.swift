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

public class PaymentViewController: NiblessViewController {

  private let store: PaymentStore

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
