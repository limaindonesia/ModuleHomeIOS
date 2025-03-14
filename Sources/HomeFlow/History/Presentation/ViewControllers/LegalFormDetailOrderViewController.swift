//
//  LegalFormDetailOrderViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 21/02/25.
//

import Foundation
import GnDKit
import AprodhitKit
import SwiftUI

public class LegalFormDetailOrderViewController: BaseViewController {
  
  private let store: LegalFormDetailOrderStore
  
  public init(
    entity: LegalFormEntity,
    storeFactory: LegalFormDetailOrderStoreFactory
  ) {
    self.store = storeFactory.makeLegalFormDetailOrderStore(entity: entity)
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    let contentView = UIHostingController(rootView: LegalFormDetailOrderView(store: store))
    addFullScreen(childViewController: contentView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    observeViewModel()
  }
  
  private func observeViewModel() {
    store.backAction
      .sink { state in
        if state {
          self.didBack()
        }
      }.store(in: &subscriptions)
  }
  
  public override func didBack() {
    super.didBack()
    
  }
  
}
