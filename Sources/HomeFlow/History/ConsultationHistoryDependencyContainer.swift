//
//  ConsultationHistoryDependencyContainer.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation

public class ConsultationHistoryDependencyContainer {
  
  public init() {
    
  }
  
  func makeMainController() -> HistoryTabPagerViewController {
    
    let consultationHistoryFactory = {
      return self.makeConsultationHistoryViewController()
    }
    
    let legalFormFactory = {
      return self.makeLegalFormViewController()
    }
    
    return HistoryTabPagerViewController(
      consultationHistoryViewControllerFactory: consultationHistoryFactory,
      legalFormViewControllerFactory: legalFormFactory
    )
    
  }
  
  func makeConsultationHistoryViewController() -> ConsultationHistoryViewController {
    return ConsultationHistoryViewController(storeFactory: self)
  }
  
  func makeLegalFormViewController() -> LegalFormViewController {
    return LegalFormViewController(storeFactory: self)
  }
  
  public func makeConsultationHistoryStore() -> ConsultationHistoryStore {
    return ConsultationHistoryStore()
  }
  
  public func makeLegalFormStore() -> LegalFormStore {
    return LegalFormStore()
  }
  
}

extension ConsultationHistoryDependencyContainer: ConsultationHistoryStoreFactory,
                                                  LegalFormStoreFactory {
  
}
