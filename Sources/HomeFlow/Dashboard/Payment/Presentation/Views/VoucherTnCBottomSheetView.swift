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
  
  public let voucher: EligibleVoucherEntity
  public var onTapUsed: (EligibleVoucherEntity) -> Void
  
  init(
    voucher: EligibleVoucherEntity,
    onTapUsed: @escaping (EligibleVoucherEntity) -> Void
  ) {
    self.voucher = voucher
    self.onTapUsed = onTapUsed
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Syarat & Ketentuan")
        .titleLexend(size: 16)
        .padding(.top, 16)
      
      HTMLWebView(
        htmlContent: voucher.tnc,
        contentHeight: $contentHeight
      )
      .frame(height: contentHeight)
      
      HStack {
        Image("ticket-discount", bundle: .module)
        
        Text(voucher.name)
          .titleLexend(size: 14)
        
        Spacer()
        
        Button {
          onTapUsed(voucher)
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
    voucher: .init(),
    onTapUsed: { code in
    }
  )
}
