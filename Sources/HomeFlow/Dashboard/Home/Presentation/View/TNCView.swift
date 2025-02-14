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
      Text("Syarat & Ketentuan")
        .titleLexend(size: 16)
        .padding(.top, 16)
      
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

