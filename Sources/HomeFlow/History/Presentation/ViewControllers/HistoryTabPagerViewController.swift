//
//  HistoryTabPagerViewController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit

public class HistoryTabPagerViewController: NiblessViewController {
  
  private let consultationHistoryViewController: ConsultationHistoryViewController
  private let legalFormViewController: LegalFormViewController
  
  public init(
    consultationHistoryViewControllerFactory: () -> ConsultationHistoryViewController,
    legalFormViewControllerFactory: () -> LegalFormViewController
  ) {
    
    self.consultationHistoryViewController = consultationHistoryViewControllerFactory()
    self.legalFormViewController = legalFormViewControllerFactory()
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
