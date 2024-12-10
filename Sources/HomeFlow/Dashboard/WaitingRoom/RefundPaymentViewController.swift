//
//  CancelledConsultationView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/12/24.
//

import Foundation
import UIKit
import GnDKit

public class RefundPaymentViewController: NiblessViewController {
  
  private let store: RefundPaymentStore
  var rootView: RefundPaymentView!
  
  public init(store: RefundPaymentStore) {
    self.store = store
    
    super.init()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  public override func loadView() {
    super.loadView()
    
    rootView = RefundPaymentView(store: store)
    self.view = rootView.contentView
    rootView.frame = self.view.frame
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
  
}
