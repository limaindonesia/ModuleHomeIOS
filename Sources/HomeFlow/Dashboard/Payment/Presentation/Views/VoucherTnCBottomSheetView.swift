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
  let constantHeight: CGFloat?
  
  public let voucher: EligibleVoucherEntity
  public var onTapUsed: (EligibleVoucherEntity) -> Void
  public var onTapCancelled: (EligibleVoucherEntity) -> Void
  
  init(
    voucher: EligibleVoucherEntity,
    constantHeight: CGFloat? = nil,
    onTapUsed: @escaping (EligibleVoucherEntity) -> Void,
    onTapCancelled: @escaping (EligibleVoucherEntity) -> Void
  ) {
    self.voucher = voucher
    self.constantHeight = constantHeight
    self.onTapUsed = onTapUsed
    self.onTapCancelled = onTapCancelled
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        Text("Syarat & Ketentuan")
          .titleLexend(size: 16)
          .padding(.top, 16)
        
        if let constantHeight = constantHeight {
          HTMLWebView(
            htmlContent: voucher.getHTMLText(),
            contentHeight: .constant(constantHeight)
          )
          .frame(height: constantHeight)
        } else {
          HTMLWebView(
            htmlContent: voucher.getHTMLText(),
            contentHeight: $contentHeight
          )
          .frame(height: contentHeight)
        }
        
        HStack {
          Image("ticket-discount", bundle: .module)
          
          Text(voucher.name)
            .titleLexend(size: 14)
          
          Spacer()
          
          Button {
            voucher.isUsed ? onTapCancelled(voucher) : onTapUsed(voucher)
          } label: {
            Text(voucher.isUsed ? "Batal" : "Pakai")
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
  
}

#Preview {
  VoucherTnCBottomSheetView(
    voucher: .init(),
    onTapUsed: { code in
      
    },
    onTapCancelled: { code in
      
    }
  )
}
