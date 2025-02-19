//
//  DocumentBaseViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import Foundation
import AprodhitKit
import GnDKit

public enum DocumentStatus: String {
  case WAITING_FOR_PAYMENT = "Menunggu Pembayaran"
  case ON_PROCESS = "Dalam Proses"
}

public enum DocumentRowType {
  case ACTIVE
  case HISTORY
}

public class DocumentBaseViewModel: Identifiable {
  
  public var id: UUID = UUID()
  public let type: DocumentRowType
  public let title: String
  
  public init(
    type: DocumentRowType,
    title: String
  ) {
    self.title = title
    self.type = type
  }
  
}
