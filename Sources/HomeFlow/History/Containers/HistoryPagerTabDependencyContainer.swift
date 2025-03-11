//
//  ConsultationHistoryDependencyContainer.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class HistoryPagerTabDependencyContainer {
  
  public let mainViewModel: MainTabbarViewModel
  public let sharedViewModel: HistoryPagerTabViewModel
  public let networkService: NetworkServiceLogic
  public let userSessionDataSource: UserSessionDataSourceLogic
  
  public init(
    mainViewModel: MainTabbarViewModel,
    networkService: NetworkServiceLogic,
    userSessionDataSource: UserSessionDataSourceLogic
  ) {
    self.mainViewModel = mainViewModel
    self.sharedViewModel = HistoryPagerTabViewModel()
    self.networkService = networkService
    self.userSessionDataSource = userSessionDataSource
  }
  
  public func makeViewController() -> HistoryPagerTabViewController {
    
    let consultationHistoryFactory = {
      return self.makeConsultationHistoryViewController()
    }
    
    let legalFormFactory = {
      return self.makeLegalFormViewController()
    }
    
    let legalFormDetailOrderFactory = { entity in
      return self.makeDetaiLegalFormViewController(entity: entity)
    }
    
    let legalFormPaymentFactory = { entity in
      return self.makeLegalFormPaymentViewController(entity: entity)
    }
    
    let legalFormPaymentCheckFactory = { entity in
      return self.makeLegalFormPaymentCheckViewController(entity: entity)
    }
    
    return HistoryPagerTabViewController(
      sharedViewModel: sharedViewModel,
      consultationHistoryViewControllerFactory: consultationHistoryFactory,
      legalFormViewControllerFactory: legalFormFactory,
      legalFormDetailOrderViewControllerFactory: legalFormDetailOrderFactory,
      legalFormPaymentViewControllerFactory: legalFormPaymentFactory,
      legalFormPaymentCheckViewControllerFactory: legalFormPaymentCheckFactory
    )
    
  }
  
  //MARK: - Make View Controller
  
  private func makeConsultationHistoryViewController() -> ConsultationHistoryViewController {
    return ConsultationHistoryViewController(storeFactory: self)
  }
  
  private func makeLegalFormViewController() -> LegalFormViewController {
    return LegalFormViewController(storeFactory: self)
  }
  
  private func makeDetaiLegalFormViewController(entity: LegalFormEntity) -> LegalFormDetailOrderViewController {
    return LegalFormDetailOrderViewController(entity: entity, storeFactory: self)
  }
  
  private func makeLegalFormPaymentViewController(entity: LegalFormEntity) -> LegalFormPaymentViewController {
    return LegalFormPaymentViewController(entity: entity, storeFactory: self)
  }
  
  private func makeLegalFormPaymentCheckViewController(entity: LegalFormEntity) -> LegalFormPaymentCheckViewController {
    
    return LegalFormPaymentCheckViewController(entity: entity, storeFactory: self)
  }
  
  //MARK: - Make Store
  
  public func makeLegalFormDetailOrderStore(entity: LegalFormEntity) -> LegalFormDetailOrderStore {
    let remote = LegalFormRemoteDataSourceImpl(service: networkService)
    let repository = LegalFormRepositoryImpl(remote: remote)
    
    return LegalFormDetailOrderStore(
      entity: entity,
      userSessionDataSource: userSessionDataSource,
      legalFormRepository: repository,
      legalFormNavigator: sharedViewModel
    )
  }
  
  public func makeLegalFormStore() -> LegalFormStore {
    let remote = LegalFormRemoteDataSourceImpl(service: networkService)
    let repository = LegalFormRepositoryImpl(remote: remote)
    return LegalFormStore(
      userSessionDataSource: userSessionDataSource,
      legalFormRepository: repository,
      legalFormNavigator: sharedViewModel,
      paymentNavigator: sharedViewModel,
      bottomSheetResponder: sharedViewModel
    )
  }
  
  public func makeLegalFormPaymentStore(entity: LegalFormEntity) -> LegalFormPaymentStore {
    
    let orderRemote = OrderProcessRemoteDataSource(service: networkService)
    let orderRepository = OrderProcessRepository(remote: orderRemote)
    
    let paymentRemote = PaymentRemoteDataSource(service: networkService)
    let paymentRepository = PaymentRepository(remote: paymentRemote)
    
    let cancelationRemote = PaymentCancelationRemoteDataSource(service: networkService)
    let cancelationRepository = PaymentCancelationRepository(remote: cancelationRemote)
    
    return LegalFormPaymentStore(
      userSessionDataSource: userSessionDataSource,
      entity: entity,
      orderProcessRepository: orderRepository,
      paymentRepository: paymentRepository,
      cancelationRepository: cancelationRepository,
      paymentNavigator: sharedViewModel,
      historyNavigator: sharedViewModel
    )
  }
  
  public func makeLegalFormPaymentCheckStore(entity: LegalFormEntity) -> LegalFormPaymentCheckStore {
    
    let legalRemote = LegalFormRemoteDataSourceImpl(service: networkService)
    let legalRepository = LegalFormRepositoryImpl(remote: legalRemote)
    
    let cancelationPaymentRemoteDataSource = PaymentCancelationRemoteDataSource(service: networkService)
    let cancelationPaymentRepository = PaymentCancelationRepository(remote: cancelationPaymentRemoteDataSource)
    
    let paymentCheckRemote = PaymentCheckRemoteDataSource(service: networkService)
    let paymentCheckRepository = PaymentCheckRepository(remote: paymentCheckRemote)
    
    return LegalFormPaymentCheckStore(
      entity: entity,
      userSessionDataSource: userSessionDataSource,
      cancelationRepository: cancelationPaymentRepository,
      legalFormRepository: legalRepository,
      paymentCheckRepository: paymentCheckRepository
    )
  }
  
  public func makeConsultationHistoryStore() -> ConsultationHistoryStore {
    let consultationRemote = ConsultationHistoryRemoteDataSourceImpl(service: networkService)
    let consultationRepository = ConsultationHistoryRepositoryImpl(remoteDataSource: consultationRemote)
    return ConsultationHistoryStore(
      userSessionDataSource: userSessionDataSource,
      consultationRepository: consultationRepository,
      advocateNavigator: mainViewModel,
      loginNavigator: mainViewModel,
      consultationNavigator: mainViewModel
    )
  }
  
}

extension HistoryPagerTabDependencyContainer: LegalFormStoreFactory,
                                              LegalFormDetailOrderStoreFactory,
                                              LegalFormPaymentStoreFactory,
                                              LegalFormPaymentCheckStoreFactory,
                                              ConsultationHistoryStoreFactory {
  
}
