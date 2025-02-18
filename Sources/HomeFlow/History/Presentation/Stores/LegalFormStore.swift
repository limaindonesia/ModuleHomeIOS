//
//  LegalFormStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import Foundation

public class LegalFormStore: ObservableObject {
  
}

public protocol LegalFormStoreFactory {
  
  func makeLegalFormStore() -> LegalFormStore
  
}
