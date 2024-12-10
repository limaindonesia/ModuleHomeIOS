//
//  RefundBottomSheetViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/12/24.
//

import Foundation
import UIKit
import GnDKit
import AprodhitKit

public class RefundBottomSheetViewController: BottomSheetContentController {
  
  var store: RefundPaymentSheetStore!

  public override func observeStore() {
    super.observeStore()
    
    store = getStore() as? RefundPaymentSheetStore
    
  }
  
}
