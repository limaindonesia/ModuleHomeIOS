//
//  TnCView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 31/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct VoucherTNCView: UIViewRepresentable {
  
  typealias UIViewType = ContentWebView
  
  let text: String
  
  func makeUIView(context: Context) -> ContentWebView {
    let contentView = ContentWebView(htmlText: text)
    return contentView
  }
  
  func updateUIView(_ uiView: ContentWebView, context: Context) {
    
  }
  
}
