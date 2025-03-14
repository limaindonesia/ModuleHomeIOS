//
//  ConsultationDependencyContainer.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/03/25.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit

public class ConsultationDependencyContainer {
  
  /*public let sharedViewModel: HistoryViewModel
  public let networkService: NetworkServiceLogic
  public let userSessionDataSource: UserSessionDataSourceLogic
  
  public init(dependencyContainer: HistoryPagerTabDependencyContainer) {
    self.networkService = dependencyContainer.networkService
    self.userSessionDataSource = dependencyContainer.userSessionDataSource
    self.sharedViewModel = HistoryViewModel()
  }
  
  //MARK: - Make View Controler
  
  public func makeViewController() -> ConsultationContainerController {
    let detailFactory = {
      return self.makeDetailConsultationViewController()
    }
    
    return ConsultationContainerController(
      sharedViewModel: sharedViewModel,
      historyViewController: makeHistoryViewController(),
      makeDetailHistoryControllerFactory: detailFactory
    )
  }
  
  public func makeHistoryViewController() -> ConsultationHistoryViewController {
    return ConsultationHistoryViewController(storeFactory: self)
  }
  
  public func makeDetailConsultationViewController() -> UIViewController {
    return UIViewController()
  }
  
  //MARK: - Make View Model
  
  public func makeConsultationHistoryStore() -> ConsultationHistoryStore {
    let remote = ConsultationHistoryRemoteDataSourceImpl(service: networkService)
    let repository = ConsultationHistoryRepositoryImpl(remoteDataSource: remote)
    return ConsultationHistoryStore(
      userSessionDataSource: userSessionDataSource,
      consultationRepository: repository,
      advocateNavigator: MockNavigator(),
      loginNavigator: MockNavigator()
    )
  }
   */
  
}

//extension ConsultationDependencyContainer: ConsultationHistoryStoreFactory {
//  
//}
