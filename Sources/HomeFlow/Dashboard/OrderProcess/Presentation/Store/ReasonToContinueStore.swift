//
//  ReasonToContinueStore.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

import Foundation
import Combine

public class ReasonToContinueStore: ObservableObject {
  
  public let arrayReasons: [ReasonEntity]
  var consultationID: Int?
  
  @Published public var selectedReason: ReasonEntity?
  @Published var reasonText: String = ""
  @Published var didTapReject: Bool = false
  @Published var didTapCancel: Bool = false
  @Published var showTextView: Bool = false
  @Published var enableButton: Bool = false
  @Published var reasonTextErrorMessage: String = ""
  @Published var selectedIndex: Int? = nil
  @Published var isTextValid: Bool = true
  
  public var subscriptions = Set<AnyCancellable>()

  public init(
    arrayReasons: [ReasonEntity],
    selectedReason: ReasonEntity?
  ) {
    self.arrayReasons = arrayReasons
    self.selectedReason = selectedReason
    
    $selectedReason
      .compactMap { $0 }
      .flatMap { item in
        self.chooseAnotherReason(item.id)
      }
      .sink { [weak self] selected in
        self?.showTextView = selected
      }.store(in: &subscriptions)

    enabledButtonOnlyWhenChoosingAnotherReason
      .sink { [weak self] enabled in
        self?.enableButton = enabled
      }.store(in: &subscriptions)

    $reasonText
      .dropFirst()
      .flatMap { self.isValidText($0) }
      .receive(on: RunLoop.main)
      .subscribe(on: RunLoop.main)
      .sink { state in
        self.isTextValid = state
        self.enableButton = state
      }.store(in: &subscriptions)
  }

  public required init() {
    fatalError()
  }
  
  public func resetReasonText() {
    isTextValid = true
  }

  public func getReason() -> String {
    guard let reason = selectedReason else { return "" }
    if reason.id == arrayReasons.last?.id {
      return reasonText
    }

    return reason.title
  }

  public func getSelectedReason() -> ReasonEntity {
    guard let reason = selectedReason else { return .init() }
    if reason.id == arrayReasons.last?.id {
      return ReasonEntity(id: reason.id, title: reasonText)
    }

    return ReasonEntity(id: reason.id, title: reason.title)
  }
  
  private func chooseAnotherReason(_ id: Int) -> AnyPublisher<Bool, Never> {
    return Future<Bool, Never> { completion in
      completion(.success(id == self.arrayReasons.last?.id))
    }.eraseToAnyPublisher()
  }

  private var enabledButtonOnlyWhenChoosingAnotherReason: AnyPublisher<Bool, Never> {
    return Publishers.CombineLatest($selectedReason, $reasonText).map { reason, text in
      guard let selectedReason = reason else { return false }
      if selectedReason.id == self.arrayReasons.last?.id {
        return !text.isEmpty && text.count >= 10
      }
      return true
    }.eraseToAnyPublisher()
  }
  
  public func findSelectedIndex() -> Int? {
    return arrayReasons.firstIndex{ $0.id == selectedReason?.id }
  }
  
  public func isValidText(_ text: String) -> AnyPublisher<Bool, Never> {
    return Future<Bool, Never> { promise in
      promise(.success(text.count > 10))
    }.eraseToAnyPublisher()
  }
  
  public func chooseAnotherReason(_ id: Int) {
    showTextView = id == self.arrayReasons.last?.id
  }
  
}
