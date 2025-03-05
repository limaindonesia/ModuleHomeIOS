//
//  ConsultationHistoryStore.swift
//  ConsultationHistoryStore
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class ConsultationHistoryStore: ObservableObject {
  
  //Dependencies
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let consultationRepository: ConsultationHistoryRepositoryLogic
  
  @Published var activeConsultationViewModels: [OngoingConsultationViewModel] = []
  @Published var historyViewModels: [HistoryConsultationViewModel] = []
  @Published var isLoading: Bool = false
  @Published var error: ErrorMessage = .init()
  
  private var userSessionData: UserSessionData? = nil
  private var page: Int = 1
  private let limit: Int = 20
  private var canLoadMorePages = true
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    consultationRepository: ConsultationHistoryRepositoryLogic
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.consultationRepository = consultationRepository
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func fetchActiveConsultations() async {
    
    indicateLoading()
    
    do {
      let models = try await consultationRepository.getConsultations(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: UserCasesParamRequest(type: .ONGOING)
      )
      
      activeConsultationViewModels = models.map { model in
        return OngoingConsultationViewModel(
          name: model.name,
          imageURL: model.imageURL,
          type: model.type,
          status: model.consultationStatus,
          timeRemaining: model.getTimeRemaining(),
          issues: model.issue,
          serviceName: model.serviceType,
          price: "Rp\(model.price)"
        ) {
          
        }
      }
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
    
  }
  
  @MainActor
  public func fetchHistoryConsultations() async {
    indicateLoading()
    page = 1
    
    do {
      let models = try await consultationRepository.getConsultations(
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
      
      historyViewModels = models.map { model in
        return HistoryConsultationViewModel(
          name: model.name,
          imageURL: model.imageURL,
          type: model.type,
          status: model.consultationStatus,
          serviceName: model.serviceType,
          date: model.dateTime,
          issues: model.issue,
          price: "Rp\(model.price)"
        ) {
          
        }
      }
      
      updatePage()
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
    
  }
  
  @MainActor
  public func loadMoreHistories() async {
    do {
      let models = try await consultationRepository.getConsultations(
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
      
      let histories = models.map { model in
        return HistoryConsultationViewModel(
          name: model.name,
          imageURL: model.imageURL,
          type: model.type,
          status: model.consultationStatus,
          serviceName: model.serviceType,
          date: model.dateTime,
          issues: model.issue,
          price: "Rp\(model.price)"
        ) {
          
        }
      }
      
      historyViewModels.append(contentsOf: histories)
      
      updatePage()
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
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
  
  public func loadMoreContentIfNeeded(currentItem item: HistoryConsultationViewModel?) async {
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
  
  //MARK: - Navigator
  
  public func naviagteToAdvocateListing() {
    
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

public protocol ConsultationHistoryStoreFactory {
  
  func makeConsultationHistoryStore() -> ConsultationHistoryStore
  
}
