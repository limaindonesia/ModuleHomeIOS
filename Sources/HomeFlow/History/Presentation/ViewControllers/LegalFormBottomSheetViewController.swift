//
//  LegalFormBottomSheetViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import UIKit
import SwiftUI
import GnDKit
import AprodhitKit

class LegalFormBottomSheetViewController: NiblessViewController {
  
  var onDismiss: (() -> Void)?
  var onCancel: (() -> Void)?
  var onNext: (() -> Void)?
  
  override func loadView() {
    super.loadView()
    
    let contentView = LegalFormBottomSheetContentView {
      self.onNext?()
    } onCancel: {
      self.onCancel?()
    }

    let rootView = UIHostingController(rootView: contentView)
    addFullScreen(childViewController: rootView)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    onDismiss?()
  }
  
}
