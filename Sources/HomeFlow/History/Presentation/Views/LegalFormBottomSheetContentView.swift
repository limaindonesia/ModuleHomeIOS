//
//  LegalFormBottomSheetContentView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct LegalFormBottomSheetContentView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image("ic_web_legaldoc", bundle: .module)
      
      Text("Akses Layanan Legal Dokumen di Web")
        .titleLexend(size: 20)
      
      Text("Layanan legal dokumen saat ini hanya tersedia di Perqara website. Silakan lanjutkan ke web untuk mengakses fitur ini.")
        .captionLexend(size: 16)
        .multilineTextAlignment(.center)
      
      HStack {
        ButtonSecondary(
          title: "Nanti",
          backgroundColor: .white,
          tintColor: .primaryInfo700,
          cornerRadius: 8,
          width: .infinity,
          height: 40
        ) {
          
        }
        
        ButtonPrimary(
          title: "Lihat di Web",
          color: Color.buttonActiveColor,
          width: .infinity,
          height: 40
        ) {
          
        }
      }
      
    }
    .padding(.horizontal, 16)
    .padding(.bottom)
  }
}

#Preview {
  LegalFormBottomSheetContentView()
}
