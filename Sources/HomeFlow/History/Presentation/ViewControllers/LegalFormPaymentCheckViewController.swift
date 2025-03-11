//
//  LegalFormPaymentCheckViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import Foundation
import AprodhitKit
import GnDKit
import SwiftUI

public class LegalFormPaymentCheckViewController: NiblessViewController {
  
  private let store: LegalFormPaymentCheckStore
  
  public init(
    entity: LegalFormEntity,
    storeFactory: LegalFormPaymentCheckStoreFactory
  ) {
    self.store = storeFactory.makeLegalFormPaymentCheckStore(entity: entity)
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    let contentView = UIHostingController(rootView: LegalFormPaymentCheckView(store: store))
    addFullScreen(childViewController: contentView)
    
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
  
}
