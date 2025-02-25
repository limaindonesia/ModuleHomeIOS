//
//  SubmitRatingBottomContentView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 24/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct SubmitRatingBottomContentView: View {
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Nilai Pengalaman Anda")
        .titleLexend(size: 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .center)
      
      Text("Berikan rating dan komentar tentang dokumen hukum ini")
        .captionLexend(size: 14)
      
      HStack {
        Image("ic_legal_form", bundle: .module)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Surat Pernyataan Ahli Waris")
            .titleLexend(size: 14)
          
          Text("30 Feb 2023, 14:00")
            .captionLexend(size: 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(12)
      .background(Color.gray050)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .frame(maxWidth: .infinity)
      
      VStack {
        StarRatingView(rating: 5, tappable: true, spacing: 8)
        
        Text("(1 kurang membantu, 5 sangat membantu)")
          .foregroundStyle(Color.gray600)
          .captionLexend(size: 12)
      }
      .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(alignment: .leading) {
        Text("Bagaimana pengalaman pembuatan dokumen?")
        Text("Sering dibahas:")
        Text("Kemudahan")
        
        ZStack(alignment: .topLeading) {
          VStack {
            TextView(
              text: .constant(""),
              textStyle: .lexendFont(style: .caption(size: 12)),
              textColor: .darkTextColor,
              backgroundColor: .gray050
            )
            .overlay(
              RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray500, lineWidth: 2)
            )
          }
          .frame(maxWidth: .infinity, idealHeight: 88)
          .background(Color.gray050)
          .cornerRadius(6)
          .padding(.horizontal, 12)
          
          
          
        }
      }
      
    }
    .padding(.horizontal, 16)
  }
  
}

#Preview {
  SubmitRatingBottomContentView()
}
