//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 17/06/25.
//


import Foundation
import AprodhitKit
import GnDKit
import Combine
import UIKit
import SwiftUI
import NaturalLanguage

public class KemenPPPAStore: ObservableObject {
  
  //Dependency
  private let advocateNavigator: OnlineAdvocateNavigator
  private let kemenPPPANavigator: KemenPPPANavigator
  
  public init() {
    self.advocateNavigator = MockNavigator()
    self.kemenPPPANavigator = MockNavigator()
  }
  
  public init(advocateNavigator: OnlineAdvocateNavigator,
              kemenPPPANavigator: KemenPPPANavigator) {
    self.advocateNavigator = advocateNavigator
    self.kemenPPPANavigator = kemenPPPANavigator
    
  }
  
  //MARK: - Navigator
  
  @MainActor
  public func navigateToAdvocateList() {
    kemenPPPANavigator.navigateToAdvocateListKemenPPPA()
  }
  
}
