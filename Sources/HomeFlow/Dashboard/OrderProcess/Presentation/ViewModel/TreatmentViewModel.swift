//
//  TreatmentViewModel.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation

public struct TreatmentViewModel {
  
  private let duration: Int
  private let type: String

  public init() {
    self.duration = 0
    self.type = ""
  }

  public init(
    duration: Int,
    type: String
  ) {
    self.duration = duration
    self.type = type
  }

  public func getDuration() -> String {
    return "\(duration) Menit"
  }

}
