//
//  VoucherBottomSheetView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI

struct VoucherBottomSheetView: View {

  @State var activateButton: Bool = false
  @State var voucher: String = ""
  private var onTap: (String) -> Void

  init(onTap: @escaping (String) -> Void) {
    self.onTap = onTap
  }

  var body: some View {
    VStack {
      Text("Kode Promo & Voucher")
        .titleLexend(size: 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(alignment: .top) {
        TextField("Tulis kode", text: $voucher)
          .padding(.horizontal, 12)
          .frame(height: 40)
          .background(Color.gray050)
          .overlay {
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray200, lineWidth: 1)
          }

        Button {
          onTap(voucher)
        } label: {
          Text("Terapakan")
            .foregroundColor(
              activateButton ? Color.white : Color.darkGray300
            )
            .titleLexend(size: 14)
        }
        .frame(width: 100, height: 40)
        .background(
          activateButton ? Color.buttonActiveColor : Color.gray100
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
      }
      .padding(.bottom, 28)

      Divider()
        .frame(height: 1)

      Text("Pilih promo untuk transaksi anda")
        .titleLexend(size: 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.bottom, 16)

      VStack(spacing: 8) {
        VStack(alignment: .center) {}
          .frame(width: 56, height: 56)
          .background(Color.gray200)
          .cornerRadius(12)
          .overlay {
            Image("ic_empty_voucher", bundle: .module)
              .resizable()
              .frame(width: 36.46, height: 29.17)
          }

        Text("Belum ada promo berlangsung")
          .captionLexend(size: 12)
      }

      Spacer()
    }
    .frame(height: 420)
  }
}

#Preview {
  VoucherBottomSheetView { _ in
    
  }
}
