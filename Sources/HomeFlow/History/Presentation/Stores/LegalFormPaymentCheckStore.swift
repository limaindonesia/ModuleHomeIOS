//
//  LegalFormPaymentCheckStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 09/03/25.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public class LegalFormPaymentCheckStore: PaymentCheckStore {
  
  //Dependency
  public let entity: LegalFormEntity
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let cancelationRepository: PaymentCancelationRepositoryLogic
  private let legalFormRepository: LegalFormRepositoryLogic
  private let paymentCheckRepository: PaymentCheckRepositoryLogic
  
  //Property
  private var userSessionData: UserSessionData? = nil
  public var documentByIDEntity: DocumentByIDEntity = .init()
  @Published public var expiredTime: TimeInterval = 0
  
  public init(
    entity: LegalFormEntity,
    userSessionDataSource: UserSessionDataSourceLogic,
    cancelationRepository: PaymentCancelationRepositoryLogic,
    legalFormRepository: LegalFormRepositoryLogic,
    paymentCheckRepository: PaymentCheckRepositoryLogic
  ) {
    self.entity = entity
    self.userSessionDataSource = userSessionDataSource
    self.cancelationRepository = cancelationRepository
    self.legalFormRepository = legalFormRepository
    self.paymentCheckRepository = paymentCheckRepository
    
    super.init()
  }
  
  //MARK: - Fetch API
  
  @MainActor
  public func fetchFirst() async {
    await fetchUserSession()
    await fetchDocumentBy(id: entity.legalFormID)
    await requestReasons()
  }
  
  @MainActor
  public func fetchDocumentBy(id: String) async {
    indicateLoading()
    
    do {
      documentByIDEntity = try await legalFormRepository.fetchDocumentByID(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        id: id
      )
      
      if let expiredDate = documentByIDEntity.paymentExpiredAt.toDate() {
        expiredTime = Date().findMinutesDiff(with: expiredDate)
        GLogger(
          .info,
          layer: "Presentation",
          message: "expired_time : \(expiredTime.timeString())"
        )
      }
      
      indicateSuccess()
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      indicateError(error: error)
    }
    
  }
  
  
  //MARK: - Fetch Local
  
  
  
  //MARK: - Other Function
  
  public override func getTimeRemaining() -> String {
    if expiredTime <= 0 {
      return "00:00"
    }
    
    return expiredTime.timeString()
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
  
  
  //MARK: - Navigator
  
  
  
  //MARK: - Observable
  
  
  
}

public protocol LegalFormPaymentCheckStoreFactory {
  func makeLegalFormPaymentCheckStore(entity: LegalFormEntity) -> LegalFormPaymentCheckStore
}
