//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 17/06/25.
//


import Foundation
import SwiftUI
import UIKit
import GnDKit
import AprodhitKit
import Combine

public class KemenPPAViewController: NiblessViewController {

  private let store: KemenPPAStore

  public init(store: KemenPPAStore) {
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

    let rootView = UIHostingController(rootView: KemenPPAView(store: store))
    addFullScreen(childViewController: rootView)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    standardNavBar(title: "Tentang Layanan")

    view.backgroundColor = UIColor.gray050
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
