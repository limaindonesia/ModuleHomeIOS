//
//  HomeDocumentActiveRowView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 12/03/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

public struct HomeDocumentActiveRowView: View {

  @ObservedObject var viewModel: DocumentActiveViewModel

  let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()

  public init(viewModel: DocumentActiveViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {

    VStack(spacing: 0) {
      CustomCorner(
        corners: [.topLeft, .topRight],
        radius: 8
      )
      .foregroundColor(Color.bgSendWarning)
      .overlay(
        HStack(spacing: 5) {
          Text(viewModel.status.rawValue)
            .foregroundColor(Color.warning600)
            .bodyLexend(size: 12)
          
          TimerTextView(paymentTimeRemaining: $viewModel.timeRemaining) { newValue in
            viewModel.timeRemaining = newValue
          } onTimerTimeUp: {
            
          }

        }.padding(.leading, 16)
      )
      .frame(height: 26)

      HStack(alignment: .top) {
        Image("ic_legal_form", bundle: .module)
        
        VStack(alignment: .leading) {
          Text(viewModel.title)
            .foregroundStyle(Color.darkTextColor)
            .titleLexend(size: 14)
          
          HStack {
            Text(viewModel.price)
              .foregroundStyle(Color.gray700)
              .titleLexend(size: 14)
            
            Spacer()
            
            ButtonPrimary(
              title: Constant.Text.GOTO_PAYMENT,
              color: Color.buttonActiveColor,
              width: 120,
              height: 30
            ) {
              viewModel.onPayment()
            }
          }
          .padding(.vertical, 8)
        }
        
      }
      .padding(.all, 8)
      .background(Color.white)
    }
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .frame(height: 160)
    .padding(.horizontal, 16)

  }

}

#Preview {
  HomeDocumentActiveRowView(viewModel: .init())
  .background(Color.gray200)
}
