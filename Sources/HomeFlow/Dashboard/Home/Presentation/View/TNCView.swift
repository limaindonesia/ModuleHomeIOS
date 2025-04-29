//
//  TNCView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 14/02/25.
//

import Foundation
import SwiftUI
import GnDKit
import AprodhitKit

struct TNCView: View {
  @Environment(\.dismiss) var dismiss
  @State var contentHeight: CGFloat = 0
  let constantHeight: CGFloat?
  let htmlText: String
  
  init(
    htmlText: String,
    constantHeight: CGFloat? = nil
  ) {
    self.htmlText = htmlText
    self.constantHeight = constantHeight
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Spacer()
        
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
            .foregroundStyle(Color.black)
            .titleStyle(size: 14)
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
      }
      
      Text("Syarat & Ketentuan")
        .titleLexend(size: 16)
      
      if let constantHeight = constantHeight {
        HTMLWebView(
          htmlContent: htmlText,
          contentHeight: .constant(constantHeight)
        )
        .frame(height: constantHeight)
      } else {
        HTMLWebView(
          htmlContent: htmlText,
          contentHeight: $contentHeight
        )
        .frame(height: contentHeight)
      }
      
      Spacer()
    }
    .padding(.horizontal, 16)
  }
  
}

#Preview {
  VoucherTnCBottomSheetView(
    voucher: .init(),
    onTapUsed: { code in },
    onTapCancelled: { code in }
  )
}

