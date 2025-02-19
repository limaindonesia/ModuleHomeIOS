//
//  TimerTextView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 30/11/24.
//

import SwiftUI

struct TimerTextView: View {
  
  @State var paymentTimeRemaining: TimeInterval = 0
  let textColor: Color
  var onUpdateTimer: (TimeInterval) -> Void
  var onTimerTimeUp: () -> Void
  
  public let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()
  
  
  init(
    paymentTimeRemaining: TimeInterval,
    textColor: Color = .white,
    onUpdateTimer: @escaping (TimeInterval) -> Void,
    onTimerTimeUp: @escaping () -> Void
  ) {
    self.paymentTimeRemaining = paymentTimeRemaining
    self.textColor = textColor
    self.onUpdateTimer = onUpdateTimer
    self.onTimerTimeUp = onTimerTimeUp
  }
  
  var body: some View {
    Text(paymentTimeRemaining.timeString())
      .foregroundStyle(textColor)
      .titleLexend(size: 10)
      .onReceive(timer) { _ in
        receiveTimer()
        onUpdateTimer(paymentTimeRemaining)
      }
  }
  
  func receiveTimer() {
    if paymentTimeRemaining > 0 {
      paymentTimeRemaining -= 1
    } else {
      paymentTimeRemaining = 0
      timer.upstream.connect().cancel()
      onTimerTimeUp()
    }
  }
  
}

#Preview {
  TimerTextView(
    paymentTimeRemaining: 300,
    onUpdateTimer: { _ in },
    onTimerTimeUp: { }
  )
}
