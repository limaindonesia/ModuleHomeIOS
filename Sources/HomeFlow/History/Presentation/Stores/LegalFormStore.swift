//
//  LegalFormStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class LegalFormStore: ObservableObject {
  
  //Dependencies
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let legalFormRepository: LegalFormRepositoryLogic
  private let legalFormNavigator: LegalFormNavigator
  private let legalFormPaymentNavigator: LegalFormPaymentNavigator
  private let paymentNavigator: PaymentNavigator
  private let bottomSheetResponder: BottomSheetResponder
  
  @Published public var activeViewModels: [DocumentBaseViewModel] = []
  @Published public var historyViewModels: [DocumentBaseViewModel] = []
  @Published public var isPresentBottomSheet: Bool = false
  @Published public var isLoading: Bool = false
  @Published public var error: ErrorMessage = .init()
  
  private var entities: [LegalFormEntity] = []
  private var userSessionData: UserSessionData? = nil
  private var page: Int = 1
  private let limit: Int = 20
  private var canLoadMorePages = true
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    legalFormRepository: LegalFormRepositoryLogic,
    legalFormNavigator: LegalFormNavigator,
    legalFormPaymentNavigator: LegalFormPaymentNavigator,
    paymentNavigator: PaymentNavigator,
    bottomSheetResponder: BottomSheetResponder
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.legalFormRepository = legalFormRepository
    self.legalFormNavigator = legalFormNavigator
    self.legalFormPaymentNavigator = legalFormPaymentNavigator
    self.paymentNavigator = paymentNavigator
    self.bottomSheetResponder = bottomSheetResponder
  }
  
  @MainActor
  func fetchActiveDocuments() async {
    activeViewModels.removeAll()
    
    do {
      entities = try await legalFormRepository.fetchLegalFormDocuments(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: UserCasesParamRequest(
          type: .ONGOING
        )
      )
      
      await mapDocumentEntities()
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
  }
  
  @MainActor
  func fetchHistoryDocuments() async {
    historyViewModels.removeAll()
    
    do {
      entities = try await legalFormRepository.fetchLegalFormDocuments(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: UserCasesParamRequest(
          type: .HISTORY,
          limit: limit,
          page: page
        )
      )
      
      await mapDocumentEntities()
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
  }
  
  @MainActor
  public func loadMoreHistories() async {
    do {
      let models = try await legalFormRepository.fetchLegalFormDocuments(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: UserCasesParamRequest(
          type: .HISTORY,
          limit: limit,
          paginate: true,
          page: page
        )
      )
      
      if models.isEmpty {
        canLoadMorePages = false
      }
      
      let histories = models.map(mapEntityToViewModel(entity:))
      historyViewModels.append(contentsOf: histories)
      
      updatePage()
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
  }
  
  @MainActor
  private func mapDocumentEntities() async {
    activeViewModels.removeAll()
    historyViewModels.removeAll()
    
    let viewModels = entities.map(mapEntityToViewModel(entity:))
    for viewModel in viewModels {
      if viewModel.type == .ACTIVE {
        activeViewModels.append(viewModel)
      } else {
        historyViewModels.append(viewModel)
      }
    }
  }
  
  //MARK: - Fetch Local
  
  public func fetchUserSessionData() async {
    do {
      userSessionData = try await userSessionDataSource.fetchData()
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
  }
  
  
  //MARK: - Other Function
  
  private func mapEntityToViewModel(entity: LegalFormEntity) -> DocumentBaseViewModel {
    if entity.type == .BOOKED {
      return DocumentActiveViewModel(
        type: .ACTIVE,
        title: entity.title,
        status: .WAITING_FOR_PAYMENT,
        timeRemaining: entity.timeRemaining,
        price: entity.price,
        onPayment: {
          self.navigateToPayment(entity)
        },
        onTimerTimesUp: {
          
        }
      )
    }
    
    if entity.type == .ON_PROGRESS {
      return DocumentOnProcessViewModel(
        type: .ACTIVE,
        title: entity.title,
        status: .ON_PROCESS,
        date: entity.getDateString(),
        price: entity.price
      ) {
        self.navigateToDetailOrder(entity)
      } onTapButton: {
        self.showBottomSheet()
      }
      
    }
    
    return DocumentHistoryViewModel(
      type: .HISTORY,
      title: entity.title,
      status: entity.status,
      date: entity.getDateString(),
      price: entity.price,
      onNext: {
        self.navigateToDetailOrder(entity)
      },
      onTapButton: {
        
      }
    )
    
  }
  
  public func loadMoreContentIfNeeded(currentItem item: DocumentHistoryViewModel?) async {
    guard let item = item else {
      return
    }
    
    if item == historyViewModels.last && canLoadMorePages{
      await loadMoreHistories()
    }
    
  }
  
  private func updatePage() {
    page += 1
  }
  
  public func showBottomSheet() {
    isPresentBottomSheet = true
    bottomSheetResponder.showBottomSheet(true)
  }
  
  public func hideBottomSheet() {
    isPresentBottomSheet = false
    bottomSheetResponder.showBottomSheet(false)
  }
  
  //MARK: - Navigator
  
  public func navigateToDetailOrder(_ entity: LegalFormEntity) {
    legalFormNavigator.navigateToDetailOrder(entity: entity)
  }
  
  public func navigateToPayment(_ entity: LegalFormEntity) {
    if entity.paymentURL.isEmpty {
      legalFormPaymentNavigator.navigateToPayment(entity: entity)
    } else {
      legalFormNavigator.navigateToCheckStatus(entity: entity)
      paymentNavigator.navigateToPaymentGateway(URL(string: entity.paymentURL))
    }
  }
  
  //MARK: - Indicate
  
  private func indicateLoading() {
    isLoading = true
  }
  
  private func indicateError(message: String) {
    isLoading = false
  }
  
  private func indicateError(error: ErrorMessage) {
    isLoading = false
    self.error = error
  }
  
  private func indicateSuccess() {
    isLoading = false
    error = .init()
  }
}

public protocol LegalFormStoreFactory {
  
  func makeLegalFormStore() -> LegalFormStore
  
}
