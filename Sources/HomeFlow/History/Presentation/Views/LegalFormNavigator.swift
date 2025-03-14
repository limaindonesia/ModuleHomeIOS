//
//  LegalFormNavigator.swift
//  AprodhitKit
//
//  Created by Ilham Prabawa on 07/03/25.
//

import Foundation
import AprodhitKit

public protocol LegalFormNavigator {
  func navigateToDetailOrder(entity: LegalFormEntity)
  func navigateToPayment(entity: LegalFormEntity)
  func navigateToCheckStatus(entity: LegalFormEntity)
  func navigateToDocumentDetail()
  func navigateBack()
}
