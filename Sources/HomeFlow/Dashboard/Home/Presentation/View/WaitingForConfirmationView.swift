//
//  WaitingForConfirmationView.swift
//
//
//  Created by Ilham Prabawa on 17/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct WaitingForConfirmationView: View {
  public let imageURL: URL?
  public let statusText: String
  public let date: String
  public let lawyersName: String
  public let issueType: String
  public let isKemenPPPA: Bool
  public let isFromHistory: Bool
  public var onTap: () -> Void

  public init(
    imageURL: URL?,
    statusText: String,
    date: String,
    lawyersName: String,
    issueType: String,
    isKemenPPPA: Bool,
    isFromHistory: Bool,
    onTap: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.statusText = statusText
    self.date = date
    self.lawyersName = lawyersName
    self.issueType = issueType
    self.isKemenPPPA = isKemenPPPA
    self.isFromHistory = isFromHistory
    self.onTap = onTap
  }

  public var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(isFromHistory ? Color.white : isKemenPPPA ? Color.success050 : Color.success200)
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
              .foregroundColor(isKemenPPPA ? Color.success700 : Color.textSendWarning)
              .bodyLexend(size: 12)
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
          width: 56,
          height: 84
        )
        .padding(.leading, 16)

        VStack(alignment: .leading) {

          VStack(alignment: .leading, spacing: 8) {
            if isKemenPPPA {
              Text(lawyersName)
                .lineLimit(0)
                .titleLexend(size: 14)

            } else {
              Text(date)
                .bodyLexend(size: 12)

              Text(lawyersName)
                .lineLimit(0)
                .titleLexend(size: 14)

            }
            
            ChipTextView(
              text: issueType,
              textColor: Color.buttonActiveColor,
              backgroundColor: Color.primary050,
              paddingVertical: 4,
              paddingHorizontal: 8
            )
            
            if isKemenPPPA {
              ChipTextView(
                text: "Hotline KemenPPPA",
                textColor: Color.gray600,
                backgroundColor: Color.gray100,
                paddingVertical: 4,
                paddingHorizontal: 8
              )
              
            }
          }
          .padding(.all, 8)

          Spacer()

          HStack {
            if isKemenPPPA {
              Text(isFromHistory ? "Rp0" : "Gratis")
                .foregroundColor(Color.gray700)
                .titleLexend(size: 14)
            }
            
            Spacer()

            if isKemenPPPA {
              ButtonPrimary(
                title: Constant.Home.Text.BACK_TO_CONSULTATION,
                color: Color.buttonActiveColor,
                width: 165,
                height: 30
              ) {
                onTap()
              }
            } else {
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
            
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 8)

        }

      }
      .background(Color.white)
    }
    .frame(height: isKemenPPPA ? 180 : 160)
    .cornerRadius(8)
    .padding(.horizontal, 16)
    .shadow(color: isFromHistory ? Color.black.opacity(0.1) : Color.clear, radius: 4, x: 0, y: 2)

  }
}

#Preview {
  WaitingForConfirmationView(
    imageURL: nil,
    statusText: "Menunggu Konfirmasi",
    date: "28 Des 2022, 14.00",
    lawyersName: "Noel S.H",
    issueType: "Pidana",
    isKemenPPPA: false,
    isFromHistory: false,
    onTap: {}
  )
}
