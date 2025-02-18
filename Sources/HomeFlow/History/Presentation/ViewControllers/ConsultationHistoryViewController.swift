//
//  ConsultationHistoryViewController.swift
//
//
//  Created by Ilham Prabawa on 27/10/23.
//

import UIKit
import AprodhitKit
import GnDKit

public class ConsultationHistoryViewController: NiblessViewController {
  
  private let store: ConsultationHistoryStore
  
  public init(storeFactory: ConsultationHistoryStoreFactory) {
    self.store = storeFactory.makeConsultationHistoryStore()
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemPink
  }
  
}
