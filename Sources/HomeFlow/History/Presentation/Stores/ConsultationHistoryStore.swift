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
  
  @Published var activeConsultationViewModels: [OngoingConsultationViewModel] = []
  @Published var historyViewModels: [HistoryConsultationViewModel] = []
  
  public init() {
    
  }
  
  @MainActor
  public func fetchActiveConsultations() async {
    activeConsultationViewModels.append(OngoingConsultationViewModel())
  }
  
  @MainActor
  public func fetchHistoryConsultations() async {
    historyViewModels.append(HistoryConsultationViewModel())
    historyViewModels.append(HistoryConsultationViewModel())
    historyViewModels.append(HistoryConsultationViewModel())
    historyViewModels.append(HistoryConsultationViewModel())
  }
  
}

public protocol ConsultationHistoryStoreFactory {
  
  func makeConsultationHistoryStore() -> ConsultationHistoryStore
  
}
