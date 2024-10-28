//
//  VoucherBottomSheetView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI

struct VoucherBottomSheetView: View {
  
  @Binding var activateButton: Bool
  @Binding var voucher: String
  @Binding var showXMark: Bool
  @Binding var voucherErrorText: String
  
  private var onTap: (String) -> Void
  
  init(
    activateButton: Binding<Bool>,
    voucher: Binding<String>,
    showXMark: Binding<Bool>,
    voucherErrorText: Binding<String>,
    onTap: @escaping (String) -> Void
  ) {
    self._activateButton = activateButton
    self._voucher = voucher
    self._showXMark = showXMark
    self._voucherErrorText = voucherErrorText
    self.onTap = onTap
  }
  
  var body: some View {
    VStack {
      Text("Kode Promo & Voucher")
        .titleLexend(size: 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(alignment: .top) {
        ZStack {
          GeometryReader { proxy in
            
            let frame = proxy.frame(in: .local)
            
            TextField("Tulis kode", text: $voucher)
              .padding(.horizontal, 12)
              .padding(.trailing, 24)
              .frame(height: 40)
              .background(Color.gray050)
              .overlay {
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.gray200, lineWidth: 1)
              }
            
            if showXMark {
              Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .position(x: frame.maxX - 20, y: frame.midY)
                .onTapGesture {
                  voucher = ""
                }
            }
          }
        }.frame(maxHeight: 40)
        
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
      
      if !voucherErrorText.isEmpty {
        Text(voucherErrorText)
          .foregroundColor(Color.danger500)
          .bodyLexend(size: 12)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 4)
          .padding(.trailing, 100)
      }
      
      Divider()
        .frame(height: 1)
        .padding(.top, 28)
      
      Text("Pilih promo untuk transaksi anda")
        .titleLexend(size: 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 16)
        .padding(.top, 16)
      
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
  VoucherBottomSheetView(
    activateButton: .constant(false),
    voucher: .constant(""),
    showXMark: .constant(false),
    voucherErrorText: .constant(""),
    onTap: { _ in }
  )
}
