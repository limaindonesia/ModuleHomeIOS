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
import Combine

public class HistoryPagerTabViewController: SlidingTabController {
  
  private let sharedViewModel: HistoryPagerTabViewModel
  private let makeConsultationHistoryViewController: () -> ConsultationHistoryViewController
  private let makeLegalFormViewController: () -> LegalFormViewController
  private let makeLegalFormDetailOrderViewController: (LegalFormEntity) -> LegalFormDetailOrderViewController
  private let makeLegalFormPaymentViewController: (LegalFormEntity) -> LegalFormPaymentViewController
  private let makeLegalFormPaymentCheckViewController: (LegalFormEntity) -> LegalFormPaymentCheckViewController
  
  private var historyViewController: ConsultationHistoryViewController?
  private var legalFormDetailViewController: LegalFormDetailOrderViewController?
  
  private var height: CGFloat = 90
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(
    sharedViewModel: HistoryPagerTabViewModel,
    consultationHistoryViewControllerFactory: @escaping () -> ConsultationHistoryViewController,
    legalFormViewControllerFactory: @escaping () -> LegalFormViewController,
    legalFormDetailOrderViewControllerFactory: @escaping (LegalFormEntity) -> LegalFormDetailOrderViewController,
    legalFormPaymentViewControllerFactory: @escaping (LegalFormEntity) -> LegalFormPaymentViewController,
    legalFormPaymentCheckViewControllerFactory: @escaping (LegalFormEntity) -> LegalFormPaymentCheckViewController
  ) {
    
    self.sharedViewModel = sharedViewModel
    self.makeConsultationHistoryViewController = consultationHistoryViewControllerFactory
    self.makeLegalFormViewController = legalFormViewControllerFactory
    self.makeLegalFormDetailOrderViewController = legalFormDetailOrderViewControllerFactory
    self.makeLegalFormPaymentViewController = legalFormPaymentViewControllerFactory
    self.makeLegalFormPaymentCheckViewController = legalFormPaymentCheckViewControllerFactory
    
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
      height: screen.height - height
    )
    
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    buildTab()
    observeViewModel()
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
    
    let consultationHistoryViewController = makeConsultationHistoryViewController()
    
    let legalFormViewController = makeLegalFormViewController()
    
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
  
  private func hideTabbar(_ state: Bool) {
    self.tabBarController?.tabBar.isHidden = state
  }
  
  private func subscribe(to publisher: AnyPublisher<LegalFormNavigation, Never>) {
    publisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] action in
        guard let self = self else { return }
        self.respond(action)
      }.store(in: &subscriptions)
  }
  
  private func respond(_ navigationAction: LegalFormNavigation) {
    switch navigationAction {
    case .present(let view):
      self.present(view)
    case .presented:
      break
    }
  }
  
  private func present(_ view: HistoryPagerTabViewState) {
    switch view {
    case .main:
      presentLegalForm()
    case .detail(let entity):
      presentDetail(entity)
    case .payment(let entity):
      presentPayment(entity)
    case .checkStatus(let entity):
      presentCheckStatus(entity)
    case .documentDetail:
      break
    case .paymentGateway(let url):
      presentPaymentGateway(url)
    case .consultationDetail:
      presentHistoryDetail()
    case .consultationHistory:
      presentConsultationHistory()
    case .openURL(let url):
      gotoURL(url)
    }
  }
  
  private func observeViewModel() {
    let publisher = sharedViewModel.$navigationAction.eraseToAnyPublisher()
    subscribe(to: publisher)
    
    sharedViewModel.$presentBottomSheet
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] state in
        guard let self = self else { return }
        if state {
          presentBottomSheet()
        }
      }.store(in: &subscriptions)
  }
  
  private func presentConsultationHistory() {
    
  }
  
  private func presentHistoryDetail() {
    
  }
  
  private func presentAdvocateListing() {
    
  }
  
  private func presentLegalForm() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  private func presentDetail(_ entity: LegalFormEntity) {
    let vc = makeLegalFormDetailOrderViewController(entity)
    navigationController?.pushViewController(vc, animated: true)
    
    //    var controllerToBePresent: LegalFormDetailOrderViewController?
    //
    //    if let vc = legalFormDetailViewController {
    //      controllerToBePresent = vc
    //    } else {
    //      controllerToBePresent = makeLegalFormDetailOrderViewController(entity)
    //      legalFormDetailViewController = controllerToBePresent
    //    }
    //
    //    if presentedViewController is LegalFormDetailOrderViewController {
    //
    //    } else {
    //      controllerToBePresent!.modalPresentationStyle = .fullScreen
    //      present(controllerToBePresent!, animated: true)
    //    }
  }
  
  private func presentBottomSheet() {
    let vc = LegalFormBottomSheetViewController()
    vc.modalPresentationStyle = .formSheet
    vc.sheetPresentationController?.detents = [.medium()]
    vc.onDismiss = {
      self.sharedViewModel.showBottomSheet(false)
    }
    
    vc.onNext = {
      self.sharedViewModel.openURL()
    }
    
    vc.onCancel = {
      self.dismiss(animated: true)
      self.sharedViewModel.showBottomSheet(false)
    }
    
    present(vc, animated: true, completion: nil)
  }
  
  private func presentPayment(_ entity: LegalFormEntity) {
    let vc = makeLegalFormPaymentViewController(entity)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func presentCheckStatus(_ entity: LegalFormEntity) {
    let vc = makeLegalFormPaymentCheckViewController(entity)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func presentPaymentGateway(_ paymentURL: URL?) {
    if let url = paymentURL,
       UIApplication.shared.canOpenURL(url) {
      
      UIApplication.shared.open(url)
    }
  }
  
  private func gotoURL(_ url: URL?) {
    if let url = url,
       UIApplication.shared.canOpenURL(url) {
      
      UIApplication.shared.open(url)
    }
  }
  
}
