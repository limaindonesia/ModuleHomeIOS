//
//  WaitingForPaymentView.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct WaitingForPaymentView: View {

  public let imageURL: URL?
  public let statusText: String
  public let date: String
  public let lawyersName: String
  public let issueType: String
  public let price: String
  public let isFromHistory: Bool
  public var onTap: () -> Void
  public var onTimerTimesUp: () -> Void

  @State var timeRemaining: TimeInterval

  let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()

  public init(
    imageURL: URL?,
    statusText: String,
    timeRemaining: TimeInterval,
    date: String,
    lawyersName: String,
    issueType: String,
    price: String,
    isFromHistory: Bool,
    onTap: @escaping () -> Void,
    onTimerTimesUp: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.statusText = statusText
    self.timeRemaining = timeRemaining
    self.date = date
    self.lawyersName = lawyersName
    self.issueType = issueType
    self.price = price
    self.isFromHistory = isFromHistory
    self.onTap = onTap
    self.onTimerTimesUp = onTimerTimesUp
  }

  public var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(isFromHistory ? Color.white : Color.bgSendWarning)
      .overlay(
        HStack(spacing: 2) {
          if isFromHistory {
            Text(statusText)
              .foregroundColor(Color.warning600)
              .font(Font(UIFont.lexendFont(style: .body(size: 12))))
              .padding(.vertical, 4)
              .padding(.horizontal, 4)
              .background(Color.warning100)
              .cornerRadius(8)
            
            Spacer()
            
          } else {
            Text(statusText)
              .foregroundColor(Color.textSendWarning)
              .bodyLexend(size: 12)
            
            Text(timeRemaining == 0 ? "" : timeRemaining.timeString())
              .foregroundColor(Color.textSendWarning)
              .titleLexend(size: 12)
              .onReceive(timer) { _ in
                receiveTimer()
              }
          }

        }
          .padding(.leading, 16)
          .padding(.top, isFromHistory ? 8 : 0)
      )
      .frame(height: isFromHistory ? 30 : 24)

      if isFromHistory {
        Divider().padding(.horizontal, 16).padding(.top, 8).background(Color.white)
      }
      
      HStack(spacing: 8) {
        OngoingAvatarImageView(
          imageURL,
          width: 100,
          height: .infinity
        )
        
        VStack(alignment: .leading) {

          VStack(alignment: .leading, spacing: 8) {
            Text(date)
              .bodyLexend(size: 12)

            Text(lawyersName)
              .lineLimit(0)
              .titleLexend(size: 14)

            ChipTextView(
              text: issueType,
              textColor: Color.buttonActiveColor,
              backgroundColor: Color.primary050,
              paddingVertical: 4,
              paddingHorizontal: 8
            )
            
          }
          .padding(.all, 8)

          Spacer()

          HStack {
            Text(price)
              .titleLexend(size: 14)

            Spacer()

            Button(
              action: {
                onTap()
              }, label: {
                HStack(spacing: 2) {
                  Text(Constant.Home.Text.GOTO_PAYMENT)
                    .foregroundColor(Color.buttonActiveColor)
                    .titleLexend(size: 12)

                  Image("ic_chevron", bundle: .module)
                }

              }
            )
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 8)

        }

      }
      .background(Color.white)
    }
    .frame(height: 160)
    .cornerRadius(8)
    .padding(.horizontal, 16)
    .shadow(color: isFromHistory ? Color.black.opacity(0.1) : Color.clear, radius: 4, x: 0, y: 2)

  }

  func receiveTimer() {
    if timeRemaining > 0 {
      timeRemaining -= 1
    }else {
      timer.upstream.connect().cancel()
      onTimerTimesUp()
    }
  }

}

#Preview {
  WaitingForPaymentView(
    imageURL: nil,
    statusText: "Menunggu Pembayaran",
    timeRemaining: 190,
    date: "28 Des 2022, 14.00",
    lawyersName: "Andra Reinhard Pasaribu, S.H., M.H.",
    issueType: "Pidana",
    price: "Rp 17.000",
    isFromHistory: false,
    onTap: {},
    onTimerTimesUp: {}
  )
}
