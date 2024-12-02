//
//  TimerTextView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 30/11/24.
//

import SwiftUI

struct TimerTextView: View {
  
  @State var paymentTimeRemaining: TimeInterval = 0
  var onUpdateTimer: (TimeInterval) -> Void
  
  public let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()
  
  var body: some View {
    Text(paymentTimeRemaining.timeString())
      .foregroundStyle(.white)
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
    }
  }
  
}

#Preview {
  TimerTextView(
    paymentTimeRemaining: 300,
    onUpdateTimer: { _ in }
  )
}
