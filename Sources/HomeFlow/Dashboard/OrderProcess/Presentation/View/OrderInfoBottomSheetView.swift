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
        .titleLexend(size: 20)
        .padding(.bottom, 16)
      
      HStack(alignment: .top, spacing: 8) {
        Image("ic_alarm", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .padding(4)
          .frame(width: 56, height: 56, alignment: .center)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Bayar dalam 10 Menit")
            .foregroundStyle(Color.primaryInfo700)
            .titleLexend(size: 14)
          
          Text("Selesaikan sebelum batas waktu, untuk menghindari kegagalan pemesanan")
            .lineSpacing(4)
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
      
      Text("Metode Pembayaran yang Tersedia:")
        .foregroundColor(Color.gray500)
        .bodyLexend(size: 14)
        .padding(.top, 16)
      
      VStack(alignment: .leading, spacing: 12) {
        
        Text("Virtual Account (4)")
          .titleLexend(size: 12)
        
        HStack {
          Image("ic_mandiri", bundle: .module)
          
          Image("ic_bri", bundle: .module)
          
          Image("ic_bni", bundle: .module)
          
          Image("ic_bca", bundle: .module)
        }
        .padding(.bottom, 12)
        
        HStack {
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .background(Color.gray200)
          
          Text("Atau")
            .captionLexend(size: 12)
          
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .background(Color.gray200)
        }
        
        Text("E-wallet (3)")
          .titleLexend(size: 12)
          .padding(.top, 12)
        
        HStack(spacing: 16) {
          
          Image("ic_payment_ovo", bundle: .module)
            
          Image("ic_payment_dana", bundle: .module)
          
          HStack {
            Image("ic_payment_shopee", bundle: .module)
            
            Divider()
              .frame(width: 2, height: 24)
            
            Image("ic_qrcode", bundle: .module)
          }
          
        }
        .frame(height: 40)
        
        VStack(alignment: .leading, spacing: 16) {
          VStack(alignment: .leading, spacing: 2) {
            Text("Pastikan Saldo E-wallet Mencukupi")
              .titleLexend(size: 14)
            
            Text("Siapkan saldo OVO, Dana, atau Shopeepay anda sebelum melakukan pembayaran")
              .lineLimit(2)
              .captionLexend(size: 12)
          }
          
          VStack(alignment: .leading, spacing: 2) {
            Text("Bisa bayar dengan QRIS")
              .titleLexend(size: 14)
              
            Text("Anda bisa membayar melalui QRIS dengan memilih metode Shopeepay")
              .lineLimit(2)
              .captionLexend(size: 12)
          }
         
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 12)
        .background(Color.white)
        .cornerRadius(8)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.gray050)
      .cornerRadius(8)
      
      Text("Pilih metode pembayaran di halaman berikutnya")
        .frame(maxWidth: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.gray500)
        .captionLexend(size: 12)
        .padding(.top, 8)
    
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(.vertical, 16)
      
      PaymentBottomView(
        title: "Biaya",
        price: price,
        totalAdjustment: "",
        buttonText: "Ke Pembayaran",
        isVoucherApplied: false,
        onTap: {
          onTap()
        }
      )
    }
    .padding(.horizontal, 16)
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
  .padding(.horizontal, 16)
}
