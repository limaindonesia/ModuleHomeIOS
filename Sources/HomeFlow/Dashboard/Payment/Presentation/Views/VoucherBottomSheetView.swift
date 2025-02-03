//
//  VoucherBottomSheetView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct VoucherBottomSheetView: View {
  
  @Binding var activateButton: Bool
  @Binding var voucher: String
  @Binding var showXMark: Bool
  @Binding var voucherErrorText: String
  @Binding var vouchers: [EligibleVoucherEntity]
  
  private var onTap: (String) -> Void
  private var onUseVoucher: (String) -> Void
  private var onClear: () -> Void
  
  init(
    activateButton: Binding<Bool>,
    voucher: Binding<String>,
    showXMark: Binding<Bool>,
    voucherErrorText: Binding<String>,
    vouchers: Binding<[EligibleVoucherEntity]>,
    onTap: @escaping (String) -> Void,
    onUseVoucher: @escaping (String) -> Void,
    onClear: @escaping () -> Void
  ) {
    self._activateButton = activateButton
    self._voucher = voucher
    self._showXMark = showXMark
    self._voucherErrorText = voucherErrorText
    self._vouchers = vouchers
    self.onTap = onTap
    self.onUseVoucher = onUseVoucher
    self.onClear = onClear
  }
  
  var body: some View {
    VStack {
      Text("Kode Promo & Voucher")
        .titleLexend(size: 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
      
      HStack(alignment: .top) {
        ZStack {
          GeometryReader { proxy in
            
            let frame = proxy.frame(in: .local)
            
            TextField("Tulis kode", text: $voucher)
              .textInputAutocapitalization(.characters)
              .captionLexend(size: 16)
              .padding(.horizontal, 12)
              .padding(.trailing, 24)
              .frame(height: 40)
              .background(Color.gray050)
              .overlay {
                RoundedRectangle(cornerRadius: 8)
                  .stroke(
                    voucherErrorText.isEmpty ? Color.gray200 : Color.danger500,
                    lineWidth: 1
                  )
              }
            
            if showXMark {
              Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .position(x: frame.maxX - 20, y: frame.midY)
                .onTapGesture {
                  voucher = ""
                  voucherErrorText = ""
                  onClear()
                }
            }
          }
        }.frame(maxHeight: 40)
        
        Button {
          if activateButton {
            onTap(voucher)
          }
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
      .padding(.horizontal, 16)
      
      if !voucherErrorText.isEmpty {
        Text(voucherErrorText)
          .foregroundColor(Color.danger500)
          .bodyLexend(size: 12)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 4)
          .padding(.trailing, 100)
          .padding(.horizontal, 16)
      }
      
      Divider()
        .frame(height: 1)
        .padding(.top, 28)
        .padding(.horizontal, 16)
      
      Text("Pilih promo untuk transaksi anda")
        .titleLexend(size: 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 16)
        .padding(.top, 16)
        .padding(.horizontal, 16)
      
      voucherListView()
      
      Spacer()
    }
    .frame(height: 420)
  }
  
  @ViewBuilder
  func voucherListView() -> some View {
    ScrollView(showsIndicators: false) {
      ForEach(vouchers, id: \.id) { voucher in
        VStack(alignment: .leading, spacing: 8) {
          HStack(alignment: .top) {
            Image("ic_probono_2", bundle: .module)
            
            VStack(alignment: .leading, spacing: 8) {
              Text(voucher.name)
                .titleLexend(size: 14)
              
              Button {
                
              } label: {
                Text("Lihat Syarat dan Ketentuan")
                  .foregroundStyle(Color.buttonActiveColor)
                  .titleLexend(size: 12)
              }
            }
            
          }
          
          Divider()
            .frame(height: 1)
          
          HStack {
            Text(voucher.dateStr)
              .foregroundStyle(Color.darkGray400)
              .captionLexend(size: 12)
            
            Spacer()
            
            ButtonPrimary(
              title: "Pakai",
              color: .buttonActiveColor,
              height: 30
            ) {
              onUseVoucher(voucher.code)
            }
          }
        }
        .padding(.all, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.gray200, radius: 5)
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 8)
    }
  }
  
  @ViewBuilder
  func voucherEmptyView() -> some View {
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
  }
}

#Preview {
  VoucherBottomSheetView(
    activateButton: .constant(false),
    voucher: .constant(""),
    showXMark: .constant(false),
    voucherErrorText: .constant(""),
    vouchers: .constant(
      [
        EligibleVoucherEntity(
          name: "Bronze Pertamina",
          code: "BRONZE12",
          tnc: "",
          expiredDate: Date()
        )
      ]
    ), onTap: { _ in
      
    }, onUseVoucher: { _ in
      
    }, onClear: { }
  )
}
