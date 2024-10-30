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
  private let isVoucherApplied: Bool
  private var onTap: () -> Void
  
  init(
    title: String,
    price: String,
    buttonText: String,
    isVoucherApplied: Bool,
    isButtonActive: Bool = true,
    onTap: @escaping () -> Void
  ) {
    self.title = title
    self.price = price
    self.buttonText = buttonText
    self.isVoucherApplied = isVoucherApplied
    self.isButtonActive = isButtonActive
    self.onTap = onTap
  }
  
  var body: some View {
    VStack(spacing: 8) {
      
      if isVoucherApplied {
        VStack {
          Text("Anda hemat Rp150.000 dalam transaksi ini")
            .foregroundColor(Color.gray700)
            .bodyLexend(size: 14)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(Color.success050)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      
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
}

#Preview {
  PaymentBottomView(
    title: "Biaya",
    price: "Rp1.000.000",
    buttonText: "Ke Pembayaran",
    isVoucherApplied: false,
    isButtonActive: true,
    onTap: {
      
    }
  )
  .padding(.all, 8)
}
