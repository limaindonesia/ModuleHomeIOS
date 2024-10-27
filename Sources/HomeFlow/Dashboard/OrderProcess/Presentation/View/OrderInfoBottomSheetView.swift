//
//  PaymentInfoBottomSheetView.swift
//
//
//  Created by Ilham Prabawa on 23/10/24.
//

import SwiftUI

struct OrderInfoBottomSheetView: View {

  private let price: String
  private var onTap: () -> Void

  init(
    price: String,
    onTap: @escaping () -> Void
  ) {
    self.price = price
    self.onTap = onTap
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Info Pembayaran")
        .titleLexend(size: 16)
        .padding(.bottom, 16)

      Text("Metode Pembayaran yang tersedia")
        .foregroundColor(Color.gray500)
        .bodyLexend(size: 14)

      HStack {
        HStack {
          Image("ic_payment_shopee", bundle: .module)

          Divider()
            .frame(width: 2, height: 24)

          Image("ic_qrcode", bundle: .module)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .overlay{
          RoundedRectangle(cornerRadius: 4)
            .stroke(Color.gray100)
        }

        Image("ic_payment_ovo", bundle: .module)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .overlay{
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.gray100)
          }

        Image("ic_payment_dana", bundle: .module)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .overlay{
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.gray100)
          }
      }
      .frame(height: 40)

      VStack(spacing: 12) {
        requirementView(
          imageName: "wallet-check",
          title: "Pastikan Saldo Cukup",
          description: "Pastikan saldo OVO, Dana, atau Shopeepay anda cukup untuk melakukan pembayaran"
        )

        requirementView(
          imageName: "check_qris",
          title: "Bayar dengan QRIS",
          description: "Anda juga dapat melakukan pembayaran melalui QRIS dengan memilih metode Shopeepay"
        )

        requirementView(
          imageName: "timer-start",
          title: "Bayar dalam 5 Menit",
          description: "Harap perhatikan batas waktu yaitu 5 menit, untuk menghindari kegagalan pemesanan"
        )

        HStack {
          Text("Pembayaran akan dilakukan dengan")
            .foregroundColor(Color.darkGray400)
            .captionLexend(size: 12)

          Image("ic_xendit", bundle: .module)
        }

      }
      .padding(.horizontal, 12)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity, maxHeight: 344)
      .background(Color.gray050)
      .cornerRadius(8)

      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(.vertical, 16)

      PaymentBottomView(
        title: "Biaya",
        price: price,
        buttonText: "Ke Pembayaran",
        onTap: {
          onTap()
        }
      )
    }
  }

  @ViewBuilder
  func requirementView(
    imageName: String,
    title: String,
    description: String
  ) -> some View {

    HStack(alignment: .top, spacing: 8) {
      Image(imageName, bundle: .module)
        .padding(4)
        .frame(width: 32, height: 32, alignment: .center)
        .background(Color.gray050)
        .cornerRadius(4)
        .overlay(
          RoundedRectangle(cornerRadius: 4)
            .inset(by: 0.38)
            .stroke(Color(red: 0.78, green: 0.81, blue: 0.86), lineWidth: 0.75)
        )

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .titleLexend(size: 14)

        Text(description)
          .captionLexend(size: 12)
      }
      .padding(.trailing, 8)
    }
    .padding(8)
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .background(Color.primaryInfo100)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .inset(by: 0.5)
        .stroke(Color.primaryInfo200)
    )
  }

}

#Preview {
  OrderInfoBottomSheetView(
    price: "",
    onTap: {}
  )
}
