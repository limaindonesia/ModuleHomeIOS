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
      .padding(.bottom, 12)
      
      VStack(spacing: 8) {
        StarRatingView(rating: 5, tappable: true, spacing: 8)
        
        Text("(1 kurang membantu, 5 sangat membantu)")
          .foregroundStyle(Color.gray600)
          .captionLexend(size: 12)
      }
      .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(alignment: .leading, spacing: 8) {
        Text("Bagaimana pengalaman pembuatan dokumen?")
          .titleLexend(size: 16)
        
        Text("Sering dibahas:")
          .foregroundStyle(Color.primaryInfo700)
          .captionLexend(size: 12)
        
        Text("Kemudahan")
          .captionLexend(size: 12)
        
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
          .background(Color.gray050)
          .frame(maxWidth: .infinity, idealHeight: 100)
          .cornerRadius(6)
          
          
          
        }
        
        HStack {
          Image("info", bundle: .module)
            .renderingMode(.template)
            .foregroundStyle(Color.buttonActiveColor)
          Text("Nama anda akan dirahasiakan oleh sistem")
            .foregroundStyle(Color.primaryInfo700)
            .captionLexend(size: 14)
          Spacer()
        }
        .padding(.all, 8)
        .background(Color.primaryInfo050)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.top, 8)
      
      ButtonPrimary(
        title: "Kirim",
        color: .gray200,
        width: .infinity,
        height: 40
      ) {
        
      }
      
    }
    .padding(.bottom, 24)
    .padding(.horizontal, 16)
  }
  
}

#Preview {
  SubmitRatingBottomContentView()
}
