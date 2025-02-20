//
//  ConsultationHistoryDependencyContainer.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class ConsultationHistoryDependencyContainer {
  
  private let networkService: NetworkServiceLogic
  private let userSessionDataSource: UserSessionDataSourceLogic
  
  public init(
    networkService: NetworkServiceLogic,
    userSessionDataSource: UserSessionDataSourceLogic
  ) {
    self.networkService = networkService
    self.userSessionDataSource = userSessionDataSource
  }
  
  public func makeViewController() -> HistoryTabPagerViewController {
    
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
  
  private func makeConsultationHistoryViewController() -> ConsultationHistoryViewController {
    return ConsultationHistoryViewController(storeFactory: self)
  }
  
  private func makeLegalFormViewController() -> LegalFormViewController {
    return LegalFormViewController(storeFactory: self)
  }
  
  public func makeConsultationHistoryStore() -> ConsultationHistoryStore {
    return ConsultationHistoryStore()
  }
  
  public func makeLegalFormStore() -> LegalFormStore {
    return LegalFormStore(legalFormRepository: MockLegalFormRepository())
  }
  
}

extension ConsultationHistoryDependencyContainer: ConsultationHistoryStoreFactory,
                                                  LegalFormStoreFactory {
  
}
