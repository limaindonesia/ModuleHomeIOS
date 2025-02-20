//
//  ConsultationHistoryViewController.swift
//
//
//  Created by Ilham Prabawa on 27/10/23.
//

import UIKit
import AprodhitKit
import GnDKit
import SwiftUI

public class ConsultationHistoryViewController: NiblessViewController {
  
  private let store: ConsultationHistoryStore
  
  public init(storeFactory: ConsultationHistoryStoreFactory) {
    self.store = storeFactory.makeConsultationHistoryStore()
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    let contentView = UIHostingController(rootView: ConsultationHistoryView(store: store))
    addFullScreen(childViewController: contentView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
  
}
