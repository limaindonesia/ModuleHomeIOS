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
  
  func getHTMLText() -> String {
    return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <link rel="preconnect" href="https://fonts.googleapis.com">
              <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
              <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;700;800&display=swap" rel="stylesheet">
            <style>
                body {
                    font-family: 'Lexend', sans-serif;
                    font-size: 14px;
                    font-weight: 300;
                    line-height: 1.6;
                    marging: 0;
                    padding: 0;
                }
                ol {
                  display: block;
                  list-style-type: decimal;
                  margin-top: 1em;
                  margin-bottom: 1em;
                  margin-left: 0;
                  margin-right: 0;
                  padding-left: 20px;
                }
            </style>
        </head>
        <body>\(text)</body>
        </html>
      """
  }
  
}
