//
//  File.swift
//  ConsultationHistoryStore
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class ConsultationHistoryStore: ObservableObject {
  
}

public protocol ConsultationHistoryStoreFactory {
  
  func makeConsultationHistoryStore() -> ConsultationHistoryStore
  
}
