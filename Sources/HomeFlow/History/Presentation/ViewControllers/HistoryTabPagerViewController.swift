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

public class HistoryTabPagerViewController: SlidingTabController {
  
  private let makeConsultationHistoryViewControllerFactory: () -> ConsultationHistoryViewController
  private let makeLegalFormViewControllerFactory: () -> LegalFormViewController
  
  public init(
    consultationHistoryViewControllerFactory: @escaping () -> ConsultationHistoryViewController,
    legalFormViewControllerFactory: @escaping () -> LegalFormViewController
  ) {
    
    self.makeConsultationHistoryViewControllerFactory = consultationHistoryViewControllerFactory
    self.makeLegalFormViewControllerFactory = legalFormViewControllerFactory
    
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    buildTab()
  }
  
  public override func setupNavBar() {
    super.setupNavBar()
    
    let titleLabel = UILabel()
    titleLabel.text = "Riwayat Konsultasi"
    titleLabel.font = .dmSansFont(style: .title(size: 16))
    
    let button = UIButton()
    button.setImage(
      UIImage(
        named: "ic_arrow_back",
        in: .module,
        compatibleWith: .none
      ),
      for: .normal
    )
    button.setTitle("", for: .normal)
    button.addTarget(
      self,
      action: #selector(didBack),
      for: .touchUpInside
    )
    
    navigationBar.hstack(
      UIView().withWidth(20),
      alignment: .fill,
      distribution: .fillProportionally
    )
    .withMargins(.allSides(15))
    .withHeight(10)
  }
  
  private func buildTab() {
    
    let consultationHistoryViewController = makeConsultationHistoryViewControllerFactory()
    
    let legalFormViewController = makeLegalFormViewControllerFactory()
    
    tabs = [
      TabModel(title: "Chat", page: consultationHistoryViewController),
      TabModel(title: "Ringkasan", page: legalFormViewController)
    ]
    
    horizontalBarBackgroundColor = UIColor.buttonActiveColor
    menuBarBackground = .white
    tintColor = UIColor.darkTextColor
    
    //Build tab menu
    build()
    
  }
  
}
