//
//  CancelledConsultationView.swift
//  HomeFlow
//
//  Created by Muhamad Yusuf on 05/12/24.
//

import Foundation
import UIKit
import GnDKit
import Combine
import AprodhitKit
import HomeFlow

public class RefundKemenPPPAViewController: NiblessViewController {
  
  private let store: RefundKemenPPPAStore
  var rootView: RefundKemenPPPAView!
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(store: RefundKemenPPPAStore) {
    self.store = store
    
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    self.navigationItem.hidesBackButton = true
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public override func loadView() {
    super.loadView()
    
    view.backgroundColor = .white
    
    rootView = RefundKemenPPPAView(store: store)
    self.view = rootView
    rootView.frame = self.view.bounds
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    observer()
  }
  
  private func observer() {
    store.gotoConsultationHistory
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { [weak self] state in
        self?.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: Notification.Name("goToHistoryTabbar"), object: nil)
      }.store(in: &subscriptions)
  }
  
}
