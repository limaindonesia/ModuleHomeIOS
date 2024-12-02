//
//  CancelReasonViewModel.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/11/24.
//

public class CancelReasonViewModel {
  public let id: Int
  public let title: String
  
  public init() {
    self.id = 0
    self.title = ""
  }
  
  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}
