//
//  LegalFormDependencyContainer.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/03/25.
//

import Foundation
import GnDKit
import AprodhitKit

public class LegalFormDependencyContainer {
  
  /*public let sharedViewModel: LegalFormViewModel
  public let networkService: NetworkServiceLogic
  public let userSessionDataSource: UserSessionDataSourceLogic
  
  public init(dependencyContainer: HistoryPagerTabDependencyContainer) {
    self.networkService = dependencyContainer.networkService
    self.userSessionDataSource = dependencyContainer.userSessionDataSource
    self.sharedViewModel = LegalFormViewModel()
  }
  
  public func makeViewController() -> LegalFormContainerController {
    
    let detailFactory = { entity in
      return self.makeDetaiLegalFormViewController(entity: entity)
    }
    
    return LegalFormContainerController(
      sharedViewModel: sharedViewModel,
      legalFormViewController: makeLegalFormViewController(),
      makeDetailLegalFormControllerFactory: detailFactory
    )
    
  }
  
  private func makeLegalFormViewController() -> LegalFormViewController {
    return LegalFormViewController(storeFactory: self)
  }
  
  private func makeDetaiLegalFormViewController(entity: LegalFormEntity) -> LegalFormDetailOrderViewController {
    return LegalFormDetailOrderViewController(entity: entity, storeFactory: self)
  }
  
  //MARK: - Make View Model
  
  public func makeLegalFormDetailOrderStore(entity: LegalFormEntity) -> LegalFormDetailOrderStore {
    return LegalFormDetailOrderStore(
      entity: entity,
      legalFormNavigator: sharedViewModel
    )
  }
  
  public func makeLegalFormStore() -> LegalFormStore {
    let remote = LegalFormRemoteDataSourceImpl(service: networkService)
    let repository = LegalFormRepositoryImpl(remote: remote)
    return LegalFormStore(
      userSessionDataSource: userSessionDataSource,
      legalFormRepository: MockLegalFormRepository(),
      legalFormNavigator: sharedViewModel,
      paymentNavigator: sharedViewModel,
      bottomSheetResponder: sharedViewModel
    )
  }*/
  
}

//extension LegalFormDependencyContainer: LegalFormStoreFactory,
//                                        LegalFormDetailOrderStoreFactory {
//  
//}
