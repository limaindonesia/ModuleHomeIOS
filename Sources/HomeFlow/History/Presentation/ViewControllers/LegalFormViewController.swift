//
//  LegalFormViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit
import SwiftUI

public class LegalFormViewController: NiblessViewController {
  
  private let store: LegalFormStore
  
  public init(storeFactory: LegalFormStoreFactory) {
    self.store = storeFactory.makeLegalFormStore()
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    let contentView = UIHostingController(rootView: LegalFormView(store: store))
    addFullScreen(childViewController: contentView)
    
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
}
