//
//  ConsultationContainerController.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 07/03/25.
//

import UIKit
import Foundation
import AprodhitKit
import GnDKit
import Combine

public class ConsultationContainerController: NiblessNavigationController {
  
  let sharedViewModel: HistoryViewModel
  
  let historyViewController: ConsultationHistoryViewController
  
  let makeDetailHistoryControllerFactory: () -> UIViewController
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(
    sharedViewModel: HistoryViewModel,
    historyViewController: ConsultationHistoryViewController,
    makeDetailHistoryControllerFactory: @escaping () -> UIViewController
  ) {
    self.sharedViewModel = sharedViewModel
    self.historyViewController = historyViewController
    self.makeDetailHistoryControllerFactory = makeDetailHistoryControllerFactory
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    observeViewModel()
  }
  
  private func subscribe(to publisher: AnyPublisher<HistoryNavigation, Never>) {
    publisher
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] action in
        guard let self = self else { return }
        self.respond(action)
      }.store(in: &subscriptions)
  }
  
  private func respond(_ navigationAction: HistoryNavigation) {
    switch navigationAction {
    case .present(let view):
      self.present(view)
    case .presented:
      break
    }
  }
  
  private func present(_ view: HistoryViewState) {
    switch view {
    case .main:
      presentHistory()
    case .detail(let entity):
      presentDetail(entity)
    }
  }
  
  private func observeViewModel(){
    let publisher = sharedViewModel.$navigationAction.eraseToAnyPublisher()
    subscribe(to: publisher)
  }
  
  private func presentHistory() {
    pushViewController(historyViewController, animated: true)
  }
  
  private func presentDetail(_ entity: ConsultationHistoryEntity) {
    pushViewController(UIViewController(), animated: true)
  }
  
}
