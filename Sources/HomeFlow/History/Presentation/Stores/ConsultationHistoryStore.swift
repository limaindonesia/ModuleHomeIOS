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
  private let advocateNavigator: OnlineAdvocateNavigator
  private let loginNavigator: LoginNavigator
  private let consultationNavigator: ConsultationHistoryNavigator
  
  @Published var activeConsultationViewModels: [OngoingConsultationViewModel] = []
  @Published var historyViewModels: [HistoryConsultationViewModel] = []
  @Published var isLoading: Bool = false
  @Published var error: ErrorMessage = .init()
  @Published var showNotSignedInStatus: Bool = false
  
  private var userSessionData: UserSessionData? = nil
  private var arrayOfUserCases: [UserCases] = []
  private var page: Int = 1
  private let limit: Int = 10
  private var canLoadMorePages = true
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    consultationRepository: ConsultationHistoryRepositoryLogic,
    advocateNavigator: OnlineAdvocateNavigator,
    loginNavigator: LoginNavigator,
    consultationNavigator: ConsultationHistoryNavigator
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.consultationRepository = consultationRepository
    self.advocateNavigator = advocateNavigator
    self.loginNavigator = loginNavigator
    self.consultationNavigator = consultationNavigator
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func fetchActiveConsultations() async {
    activeConsultationViewModels.removeAll()
    
    indicateLoading()
        
    do {
      let (models, _) = try await consultationRepository.getConsultations(
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
          price: model.price
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
    historyViewModels.removeAll()
    arrayOfUserCases.removeAll()
    
    guard let userSessionData = userSessionData else {
      showNotSignedInStatus = true
      return
    }
    
    indicateLoading()
    page = 1
    
    do {
      let (models, userCases) = try await consultationRepository.getConsultations(
        headers: HeaderRequest(token: userSessionData.remoteSession.remoteToken),
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
      
      arrayOfUserCases = userCases
      
      historyViewModels = models.map { model in
        return HistoryConsultationViewModel(
          name: model.name,
          imageURL: model.imageURL,
          type: model.type,
          status: model.consultationStatus,
          serviceName: model.serviceType,
          date: model.dateTime,
          issues: model.issue,
          price: model.price
        ) {
          
        } onTap: {
          self.navigateToDetailHistory(entity: model)
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
    
    guard let userSessionData = userSessionData else { return }
    
    do {
      let (models, userCases) = try await consultationRepository.getConsultations(
        headers: HeaderRequest(token: userSessionData.remoteSession.remoteToken),
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
          price: model.price
        ) {
          
        } onTap:{
          self.navigateToDetailHistory(entity: model)
        }
      }
      
      historyViewModels.append(contentsOf: histories)
      arrayOfUserCases.append(contentsOf: userCases)
      
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
      
      showNotSignedInStatus = true
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
    advocateNavigator.navigateToListAdvocate(
      categoryAdvocate: "",
      listCategoryID: [],
      listSkillAdvocate: [],
      listingType: "GENERAL",
      isKemenPPPA: false,
      sktmModel: nil
    )
  }
  
  public func navigateToLogin() {
    loginNavigator.navigateToLogin()
  }
  
  public func navigateToDetailHistory(entity: ConsultationHistoryEntity) {
    if let userCases = arrayOfUserCases.filter({ $0.id == entity.id }).first {
      consultationNavigator.navigateToDetailHistory(userCases)
    }
  }
  
  public func didBack() {
    advocateNavigator.navigateBack()
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
