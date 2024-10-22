//
//  WaitingForConfirmationView.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct WaitingForConfirmationView: View {
  private let imageURL: URL?
  private let statusText: String
  private let date: String
  private let lawyersName: String
  private let issueType: String
  private var onTap: () -> Void

  init(
    imageURL: URL?,
    statusText: String,
    date: String,
    lawyersName: String,
    issueType: String,
    onTap: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.statusText = statusText
    self.date = date
    self.lawyersName = lawyersName
    self.issueType = issueType
    self.onTap = onTap
  }

  var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(Color.success200)
      .overlay(
        Text(statusText)
          .foregroundColor(Color.successColor)
          .bodyStyle(size: 12)
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
              .lineLimit(2)
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
            Spacer()

            Button(
              action: {
                onTap()
              }, label: {
                HStack(spacing: 2) {
                  Text(Constant.Home.Text.BACK_TO_CONSULTATION)
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
}

#Preview {
  WaitingForConfirmationView(
    imageURL: nil,
    statusText: "Menunggu Konfirmasi",
    date: "28 Des 2022, 14.00",
    lawyersName: "Noel S.H",
    issueType: "Pidana",
    onTap: {}
  )
}
