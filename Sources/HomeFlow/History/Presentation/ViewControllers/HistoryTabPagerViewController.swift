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
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    view.frame = .init(
      x: 0,
      y: 0,
      width: screen.width,
      height: screen.height - 95
    )

  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    buildTab()
  }
  
  public override func setupNavBar() {
    super.setupNavBar()
    
    navigationBar.hstack(
      alignment: .fill,
      distribution: .fillProportionally
    )
    .withMargins(.allSides(15))
    .withHeight(80)
  }
  
  private func buildTab() {
    
    let consultationHistoryViewController = makeConsultationHistoryViewControllerFactory()
    
    let legalFormViewController = makeLegalFormViewControllerFactory()
    
    tabs = [
      TabModel(title: "Konsultasi", page: consultationHistoryViewController),
      TabModel(title: "Dokumen Hukum", page: legalFormViewController)
    ]
    
    horizontalBarBackgroundColor = UIColor.buttonActiveColor
    menuBarBackground = .white
    tintColor = UIColor.darkTextColor
    
    //Build tab menu
    build()
    
  }
  
}
