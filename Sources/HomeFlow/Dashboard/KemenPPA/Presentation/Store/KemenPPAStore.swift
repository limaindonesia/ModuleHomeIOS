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

public class KemenPPAStore: ObservableObject {
  
  //Dependency
  private let advocateNavigator: OnlineAdvocateNavigator
  
  
  public init() {
    self.advocateNavigator = MockNavigator()
  }
  
  public init(advocateNavigator: OnlineAdvocateNavigator) {
    self.advocateNavigator = advocateNavigator
    
  }
  
  //MARK: - Navigator
  
  @MainActor
  public func navigateToAdvocateList() {
    advocateNavigator.navigateToListAdvocate(
      categoryAdvocate: "",
      listCategoryID: [],
      listSkillAdvocate: [],
      listingType: "GENERAL",
      sktmModel: nil
    )
  }
  
}
