//
//  CancelledConsultationView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/12/24.
//

import Foundation
import UIKit
import GnDKit

public class CancelledConsultationViewController: UIViewController {
  
  var rootView: CancelledConsultationView!

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  public override func loadView() {
    super.loadView()
  }
  
  public override func viewDidLoad() {
    
    rootView = UINib(
      nibName: "CancelledConsultationView",
      bundle: nil
    ).instantiate(withOwner: self).first as? CancelledConsultationView
    
    self.view = rootView
    rootView.frame = self.view.frame
  }
  
}
