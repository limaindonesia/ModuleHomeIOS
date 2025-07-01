//
//  LoginBottomSheetViewController.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 15/05/25.
//

import Foundation
import GnDKit
import AprodhitKit

class KemenPPPALoginBottomSheetViewController: BottomSheetContentController {
  
  var store: KemenPPPALoginBottomSheetStore!

  public override func observeStore() {
    super.observeStore()
    
    store = getStore() as? KemenPPPALoginBottomSheetStore
    
  }
  
}
