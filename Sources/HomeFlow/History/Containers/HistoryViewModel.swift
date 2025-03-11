//
//  HistoryViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/03/25.
//

import Foundation
import GnDKit

public typealias HistoryNavigation = NavigationAction<HistoryViewState>

public class HistoryViewModel {
 
  @Published public var navigationAction: HistoryNavigation = .present(view: .main)
  
  public init() {}
  
}
