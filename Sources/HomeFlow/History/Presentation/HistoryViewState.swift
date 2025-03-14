//
//  HistoryViewState.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 06/03/25.
//

public enum HistoryViewState {
  case main
  case detail(ConsultationHistoryEntity)
}

extension HistoryViewState: Equatable {
  public static func == (lhs: HistoryViewState, rhs: HistoryViewState) -> Bool {
    switch (lhs, rhs) {
    case (.main, .main):
      return true
    case (.detail(_), .detail(_)):
      return true
    case (.main, _):
      return false
    case (.detail(_), _):
      return false
    }
  }
  
  
}
