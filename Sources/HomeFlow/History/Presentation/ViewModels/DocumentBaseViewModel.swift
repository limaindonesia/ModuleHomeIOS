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
  case REJECTED = "Dibatalkan"
  case DONE = "Selesai"
  
  public static func map(_ status: String) -> DocumentStatus {
    if status == "REJECTED" {
      return .REJECTED
    }
    
    if status == "DONE" {
      return .DONE
    }
    
    if status == "ON_PROCESS" {
      return .ON_PROCESS
    }
    
    if status == "WAITING_FOR_PAYMENT" {
      return .WAITING_FOR_PAYMENT
    }
    
    return .DONE
  }
}

public enum DocumentRowType {
  case ACTIVE
  case HISTORY
}

public class DocumentBaseViewModel: Identifiable {
  
  public var id: UUID = UUID()
  public let type: DocumentRowType
  public let title: String
  
  public init() {
    self.title = ""
    self.type = .HISTORY
  }
  
  public init(
    type: DocumentRowType,
    title: String
  ) {
    self.title = title
    self.type = type
  }
  
}
