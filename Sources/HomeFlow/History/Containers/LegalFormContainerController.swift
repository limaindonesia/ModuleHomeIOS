//
//  LegalFormContainerController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 07/03/25.
//

import UIKit
import Foundation
import AprodhitKit
import GnDKit
import Combine

/*public class LegalFormContainerController: NiblessNavigationController {
  
  let sharedViewModel: LegalFormViewModel
  
  let legalFormViewController: LegalFormViewController
  
  let makeDetailLegalFormControllerFactory: (LegalFormEntity) -> LegalFormDetailOrderViewController
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(
    sharedViewModel: LegalFormViewModel,
    legalFormViewController: LegalFormViewController,
    makeDetailLegalFormControllerFactory: @escaping (LegalFormEntity) -> LegalFormDetailOrderViewController
  ) {
    self.sharedViewModel = sharedViewModel
    self.legalFormViewController = legalFormViewController
    self.makeDetailLegalFormControllerFactory = makeDetailLegalFormControllerFactory
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    observeViewModel()
  }
  
  private func subscribe(to publisher: AnyPublisher<LegalFormNavigation, Never>) {
    publisher
      .removeDuplicates()
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
    
  }
  
  private func observeViewModel(){
    let publisher = sharedViewModel.$navigationAction.eraseToAnyPublisher()
    subscribe(to: publisher)
  }
  
  private func presentLegalForm() {
    pushViewController(legalFormViewController, animated: true)
  }
  
  private func presentDetail(_ entity: LegalFormEntity) {
    pushViewController(makeDetailLegalFormControllerFactory(entity), animated: true)
  }
  
}*/
