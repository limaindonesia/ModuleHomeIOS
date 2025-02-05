//
//  VoucherTnCBottomSheetView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct VoucherTnCBottomSheetView: View {
  
  @State var contentHeight: CGFloat = 0
  
  public let voucherName: String
  public let voucherCode: String
  public let voucherTnC: String
  public var onTapUsed: (String) -> Void
  
  init(
    voucherName: String,
    voucherTnC: String,
    voucherCode: String,
    onTapUsed: @escaping (String) -> Void
  ) {
    self.voucherName = voucherName
    self.voucherTnC = voucherTnC
    self.voucherCode = voucherCode
    self.onTapUsed = onTapUsed
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Syarat & Ketentuan")
        .titleLexend(size: 16)
        .padding(.top, 16)
      
      HTMLWebView(
        htmlContent: voucherTnC,
        contentHeight: $contentHeight
      )
      .frame(height: contentHeight)
      
      HStack {
        Image("ticket-discount", bundle: .module)
        
        Text(voucherName)
          .titleLexend(size: 14)
        
        Spacer()
        
        Button {
          onTapUsed(voucherCode)
        } label: {
          Text("Pakai")
            .foregroundStyle(Color.buttonActiveColor)
            .titleLexend(size: 14)
        }
        
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, idealHeight: 44)
      .background(Color.primaryInfo100)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.primaryInfo050, lineWidth: 1)
      }
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  VoucherTnCBottomSheetView(
    voucherName: "Bronze Pertamina",
    voucherTnC: "",
    voucherCode: "",
    onTapUsed: { code in
    }
  )
}
