//
//  OrderProcessViewController.swift
//
//
//  Created by Ilham Prabawa on 22/10/24.
//

import Foundation
import SwiftUI
import UIKit
import GnDKit
import AprodhitKit
import Combine

public class OrderProcessViewController: NiblessViewController {

  private let store: OrderProcessStore

  //Variable
  private var subscriptions = Set<AnyCancellable>()

  public init(store: OrderProcessStore) {
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

    let rootView = UIHostingController(
      rootView: OrderProcessView(store: store)
    )

    addFullScreen(childViewController: rootView)

  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    standardNavBar(title: "Proses Pesanan")

    view.backgroundColor = UIColor.gray050

    observeStore()

  }

  private func observeStore() {
    store.$isPresentChangeCategoryIssue
      .filter { $0 == true }
      .receive(on: RunLoop.main)
      .sink { _ in
        self.showChangeCategoryPopUp()
      }.store(in: &subscriptions)
  }

  private func showChangeCategoryPopUp() {
    
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
