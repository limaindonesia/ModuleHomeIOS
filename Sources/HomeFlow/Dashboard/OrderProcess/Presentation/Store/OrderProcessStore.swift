//
//  OrderProcessStore.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import Foundation
import AprodhitKit

public class OrderProcessStore: ObservableObject {

  //Dependency
  private let advocate: Advocate

  @Published public var issueText: String = "Lorem ipsum"
  @Published public var lawyerInfoViewModel: LawyerInfoViewModel = .init()
  @Published public var categoryViewModel: CategoryViewModel = .init()

  public init(advocate: Advocate) {
    self.advocate = advocate
  }

  public func changeCategory() {

  }

  public func navigateToPayment() {

  }

  public func navigateToRequestProbono() {

  }

}

public protocol OrderProcessStoreFactory {
  func makeOrderProcessStore() -> OrderProcessStore
}
