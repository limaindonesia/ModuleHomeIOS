//
//  WaitingForPaymentView.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct WaitingForPaymentView: View {

  private let imageURL: URL?
  private let statusText: String
  private let date: String
  private let lawyersName: String
  private let issueType: String
  private let price: String
  private var onTap: () -> Void

  @State var timeRemaining: TimeInterval

  let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()

  init(
    imageURL: URL?,
    statusText: String,
    timeRemaining: TimeInterval,
    date: String,
    lawyersName: String,
    issueType: String,
    price: String,
    onTap: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.statusText = statusText
    self.timeRemaining = timeRemaining
    self.date = date
    self.lawyersName = lawyersName
    self.issueType = issueType
    self.price = price
    self.onTap = onTap
  }

  var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(Color.bgSendWarning)
      .overlay(
        HStack(spacing: 2) {
          Text(statusText)
            .foregroundColor(Color.textSendWarning)
            .bodyStyle(size: 12)

          Text(timeRemaining == 0 ? "" : timeRemaining.timeString())
            .foregroundColor(Color.textSendWarning)
            .titleStyle(size: 12)
            .onReceive(timer) { _ in
              receiveTimer()
            }

        }.padding(.leading, 16)
      )
      .frame(height: 24)

      HStack(spacing: 8) {
        OngoingAvatarImageView(
          imageURL,
          width: 88,
          height: .infinity
        )
        
        VStack(alignment: .leading) {

          VStack(alignment: .leading, spacing: 8) {
            Text(date)
              .bodyStyle(size: 12)

            Text(lawyersName)
              .lineLimit(0)
              .titleStyle(size: 14)

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
              .titleStyle(size: 14)

            Spacer()

            Button(
              action: {
                onTap()
              }, label: {
                HStack(spacing: 2) {
                  Text(Constant.Home.Text.GOTO_PAYMENT)
                    .foregroundColor(Color.buttonActiveColor)
                    .titleStyle(size: 12)

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

  }

  func receiveTimer() {
    if timeRemaining > 0 {
      timeRemaining -= 1
    }else {
      timer.upstream.connect().cancel()
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
    onTap: {}
  )
}
