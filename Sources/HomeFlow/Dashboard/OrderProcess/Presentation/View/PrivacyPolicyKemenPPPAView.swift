//
//  PrivacyPolicyKemenPPPAView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct PrivacyPolicyKemenPPPAView: View {
  
  private let htmlText: String
  private var onNext: () -> Void
  
  @State var height: CGFloat = .zero
  @State var agreed: Bool = false
  
  public init(htmlText: String, onNext: @escaping () -> Void) {
    self.htmlText = htmlText
    self.onNext = onNext
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text("Baca dan Setujui Ketentuan")
        .titleLexend(size: 20)
        .padding(.horizontal)
      
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading) {
          HStack(alignment: .top) {
            Image("info", bundle: .module)
              .resizable()
              .frame(width: 13.3, height: 13.3)
            
            Text("Persetujuan diperlukan sebelum melanjutkan proses konsultasi")
              .foregroundStyle(Color.warning900)
              .captionLexend(size: 12)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(Color.warning050)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay {
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.warning200, lineWidth: 1)
          }
          .padding(.horizontal, 16)
          
          HTMLNewWebView(
            htmlContent: htmlText.wrappedInHTML,
            contentHeight: $height
          )
          .frame(height: height)
          
          LineShape()
            .stroke(
              Color.gray200,
              style: StrokeStyle(
                lineWidth: 1,
                lineJoin: .round,
                dash: [10, 5]
              )
            )
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.horizontal, 16)
          
          HStack(alignment: .top) {
            RoundedCheckBoxView(isSelected: agreed) {
              agreed.toggle()
            }
            
            Text("Saya menyetujui semua syarat ketentuan layanan ini")
              .bodyLexend(size: 14)
          }
          .padding(.horizontal, 16)
          .padding(.vertical)
        }
        .padding(.top)
      }
      
      ButtonPrimary(
        title: "Setuju & Mulai Konsultasi",
        color: .buttonActiveColor,
        width: .infinity,
        height: 40,
        isActive: agreed
      ) {
        onNext()
      }
      .padding(.horizontal, 16)
      .padding(.bottom)
    }
  }
  
}

#Preview {
  PrivacyPolicyKemenPPPAView(htmlText: "") {
    
  }
}
