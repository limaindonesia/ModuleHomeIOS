//
//  LegalDocumentRemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/03/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol LegalDocumentRemoteDataSourceLogic {
  
}

public class LegalDocumentRemoteDataSourceImpl: LegalDocumentRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
}
