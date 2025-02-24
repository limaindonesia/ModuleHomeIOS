//
//  LegalFormStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation

public class LegalFormStore: ObservableObject {
  
  //Dependencies
  private let legalFormRepository: LegalFormRepositoryLogic
  
  @Published var activeViewModels: [DocumentBaseViewModel] = []
  @Published var historyViewModels: [DocumentBaseViewModel] = []
  @Published var isPresentBottomSheet: Bool = false
  
  private var entities: [LegalFormDocumentEntity] = []
  
  public init(legalFormRepository: LegalFormRepositoryLogic) {
    self.legalFormRepository = legalFormRepository
  }
  
  @MainActor
  func fetchDocuments() async {
    do {
      entities = try await legalFormRepository.fetchLegalFormDocuments()
      await mapDocumentEntities()
    } catch {
      
    }
  }
  
  @MainActor
  private func mapDocumentEntities() async {
    let viewModels = entities.map(mapEntityToViewModel(entity:))
    for viewModel in viewModels {
      if viewModel.type == .ACTIVE {
        activeViewModels.append(viewModel)
      } else {
        historyViewModels.append(viewModel)
      }
    }
  }
  
  private func mapEntityToViewModel(entity: LegalFormDocumentEntity) -> DocumentBaseViewModel {
    if entity.type == "ACTIVE" {
      if entity.status == "WAITING_FOR_PAYMENT" {
        return DocumentActiveViewModel(
          type: .ACTIVE,
          title: entity.title,
          status: .WAITING_FOR_PAYMENT,
          timeRemaining: entity.timeRemaining,
          price: entity.price,
          onPayment: {}
        )
      } else {
        return DocumentOnProcessViewModel(
          type: .ACTIVE,
          title: entity.title,
          status: .ON_PROCESS,
          date: entity.date,
          price: entity.price,
          onNext: {}
        )
      }
    }
    
    return DocumentHistoryViewModel(
      type: .HISTORY,
      title: entity.title,
      status: DocumentStatus.map(entity.status),
      date: entity.date,
      price: entity.price,
      onNext: {}
    )
  }
  
}

public protocol LegalFormStoreFactory {
  
  func makeLegalFormStore() -> LegalFormStore
  
}
