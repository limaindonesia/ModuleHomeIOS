//
//  LegalFormPaymentViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import Foundation
import AprodhitKit
import GnDKit
import SwiftUI

public class LegalFormPaymentViewController: NiblessViewController {
  
  private let entity: LegalFormEntity
  private let store: LegalFormPaymentStore
  
  public init(
    entity: LegalFormEntity,
    storeFactory: LegalFormPaymentStoreFactory
  ) {
    self.entity = entity
    self.store = storeFactory.makeLegalFormPaymentStore(entity: entity)
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    let contentView = UIHostingController(rootView: LegalFormPaymentView(store: store))
    addFullScreen(childViewController: contentView)
    
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
  
}
