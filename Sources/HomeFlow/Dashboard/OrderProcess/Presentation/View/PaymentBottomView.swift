//
//  PaymentBottomView.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import SwiftUI
import AprodhitKit

struct PaymentBottomView: View {

  private let title: String
  private let price: String
  private let buttonText: String
  private let isButtonActive: Bool
  private var onTap: () -> Void

  init(
    title: String,
    price: String,
    buttonText: String,
    isButtonActive: Bool = true,
    onTap: @escaping () -> Void
  ) {
    self.title = title
    self.price = price
    self.buttonText = buttonText
    self.isButtonActive = isButtonActive
    self.onTap = onTap
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(title)
          .bodyLexend(size: 12)

        Text(price)
          .foregroundColor(Color.buttonActiveColor)
          .titleLexend(size: 14)
      }

      Spacer()

      PositiveButton(
        title: buttonText,
        isActive: isButtonActive
      ) {
        if isButtonActive {
          onTap()
        }
      }
      .frame(width: 156, height: 40)
    }
  }
}

#Preview {
  PaymentBottomView(
    title: "Biaya",
    price: "Rp1.000.000",
    buttonText: "Ke Pembayaran",
    isButtonActive: true,
    onTap: {

    }
  )
}
