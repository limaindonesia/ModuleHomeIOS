//
//  LegalFormDetailOrderStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/03/25.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public class LegalFormDetailOrderStore: ObservableObject {
  
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let legalFormNavigator: LegalFormNavigator
  private let legalFormRepository: LegalFormRepositoryLogic
  
  @Published public var entity: LegalFormEntity
  @Published public var showSummary: Bool = false
  @Published public var showRating: Bool = false
  @Published public var isLoading: Bool = false
  @Published public var showErrorMessage: Bool = false
  @Published public var errorMessage: ErrorMessage = .init()
  @Published public var isPresentRatingBottomSheet: Bool = false
  @Published public var buttonViewModel: ButtonViewModel = .init()
  
  public var backAction = PassthroughSubject<Bool, Never>()
  public var documentByIDEntity: DocumentByIDEntity = .init()
  private var userSessionData: UserSessionData? = nil
  
  public init(
    entity: LegalFormEntity,
    userSessionDataSource: UserSessionDataSourceLogic,
    legalFormRepository: LegalFormRepositoryLogic,
    legalFormNavigator: LegalFormNavigator
  ) {
    self.entity = entity
    self.userSessionDataSource = userSessionDataSource
    self.legalFormRepository = legalFormRepository
    self.legalFormNavigator = legalFormNavigator
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func fetchDocumentBy(id: String) async {
    indicateLoading()
    
    do {
      documentByIDEntity = try await legalFormRepository.fetchDocumentByID(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        id: id
      )
      
      indicateSuccess()
      
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
  
  
  //MARK: - Other function
  
  public func readStatus() {
    if entity.status == .ON_PROCESS {
      showSummary =  false
      showRating = false
      return
    }
    
    showSummary = entity.status == .DONE && !documentByIDEntity.isClientRated
    showRating = entity.status == .DONE && documentByIDEntity.isClientRated
    
    if entity.status == .ON_PROCESS {
      buttonViewModel = .init(
        title: "Lanjutkan",
        onTap: {
          self.legalFormNavigator.navigateToWeb()
      })
    } else if entity.status == .DONE {
      buttonViewModel = .init(
        title: "Lihat Dokumen",
        onTap: {
          self.legalFormNavigator.navigateToDocumentDetail(url: nil)
      })
    }
  }
  
  
  //MARK: - Navigator
  
  
  public func didBack() {
    backAction.send(true)
    legalFormNavigator.navigateBack()
  }
  
  //MARK: - Indicate
  
  
  private func indicateLoading() {
    isLoading = true
  }
  
  private func indicateError(message: String) {
    isLoading = false
    showErrorMessage = true
    errorMessage = .init(title: "Gagal", message: message)
  }
  
  private func indicateError(error: ErrorMessage) {
    isLoading = false
    showErrorMessage = true
    errorMessage = error
  }
  
  private func indicateSuccess() {
    isLoading = false
  }
  
  
  //MARK: - Observable
  
  
  
}

public protocol LegalFormDetailOrderStoreFactory {
  func makeLegalFormDetailOrderStore(entity: LegalFormEntity) -> LegalFormDetailOrderStore
}

public struct ButtonViewModel {
  public let title: String
  public var onTap: () -> Void
  
  public init() {
    self.title = ""
    self.onTap = {}
  }
  
  public init(title: String, onTap: @escaping () -> Void) {
    self.title = title
    self.onTap = onTap
  }
}
