//
//  OngoingConsultationView.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct OngoingConsultationView: View {
  private let imageURL: URL?
  private let statusColor: Color
  private let statusText: String
  private let statusTextColor: Color
  private let date: String
  private let lawyersName: String
  private let issueType: String
  private let buttonText: String
  private var onTap: () -> Void

  init(
    imageURL: URL?,
    statusText: String,
    statusColor: Color,
    statusTextColor: Color,
    date: String,
    lawyersName: String,
    issueType: String,
    buttonText: String,
    onTap: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.statusColor = statusColor
    self.statusText = statusText
    self.statusTextColor = statusTextColor
    self.date = date
    self.lawyersName = lawyersName
    self.issueType = issueType
    self.buttonText = buttonText
    self.onTap = onTap
  }

  var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(statusColor)
      .overlay(
        Text(statusText)
          .foregroundColor(statusTextColor)
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
                  Text(buttonText)
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
  OngoingConsultationView(
    imageURL: nil,
    statusText: "Menunggu Konfirmasi",
    statusColor: Color.errorColor,
    statusTextColor: Color.errorColor,
    date: "28 Des 2022, 14.00",
    lawyersName: "Noel S.H",
    issueType: "Pidana",
    buttonText: "Tidak terjawab",
    onTap: {}
  )
}
