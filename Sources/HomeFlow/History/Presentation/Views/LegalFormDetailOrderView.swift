//
//  LegalFormDetailOrderView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 21/02/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct LegalFormDetailOrderView: View {
  var body: some View {
    
    VStack(alignment: .leading, spacing: 12) {
      
      HStack {
        
        Image("ic_legal_form", bundle: .module)
        
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text("#1234567891")
              .captionLexend(size: 12)
            
            Spacer()
            
            Text("Dalam Proses")
              .foregroundStyle(Color.warning600)
              .titleLexend(size: 10)
              .padding(.horizontal, 6)
              .padding(.vertical, 4)
              .background(Color.warning100)
              .cornerRadius(10)
          }
          
          Text("Surat Pernyataan Ahli Waris")
            .titleLexend(size: 14)
          
          Text("30 Feb 2023, 14:00")
            .captionLexend(size: 12)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 16)
      
      Divider()
        .background(Color.gray100)
        .frame(maxWidth: .infinity, maxHeight: 1)
      
      ButtonPrimary(
        title: "Lanjutkan",
        color: .buttonActiveColor,
        width: .infinity,
        height: 40
      ) {
        
      }
      .padding(.horizontal, 16)
    }
    .padding(.vertical, 12)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
    }
    
  }
  
}

#Preview {
  LegalFormDetailOrderView()
}
