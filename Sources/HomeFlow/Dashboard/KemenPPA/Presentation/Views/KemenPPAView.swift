//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 17/06/25.
//


import SwiftUI
import AprodhitKit
import GnDKit
import Lottie

public struct KemenPPAView: View {
  
  @ObservedObject var store: KemenPPAStore
  @State private var reader: ScrollViewProxy?
  
  private init() {
    self.store = .init()
  }
  
  public init(store: KemenPPAStore) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack {
        ScrollViewReader { proxy in
          ScrollView(showsIndicators: false) {
            
            VStack(spacing: 12) {
              Image("ic_kemenPPA_service", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 342)
                .padding(.top, 16)
              
              Divider().background(Color.gray100)
                .padding(.horizontal, 16)
                .padding(.top, 16)
              
              Text("Tentang Layanan")
                .titleLexend(size: 16)
                .foregroundStyle(Color.gray700)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
              
              Text("Layanan ini memberikan akses perlindungan hukum yang cepat, aman, dan ramah bagi perempuan dan anak korban kekerasan.")
                .captionLexend(size: 14)
                .foregroundStyle(Color.gray700)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
              
              Text("Didukung oleh kolaborasi antara Kementerian Pemberdayaan Perempuan dan Perlindungan Anak (KemenPPPA RI) dan Perhimpunan Advokat Indonesia (PERADI), serta difasilitasi oleh Perqara sebagai platform hukum digital, layanan ini memastikan Anda bisa:")
                .captionLexend(size: 14)
                .foregroundStyle(Color.gray700)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
              
              Text("  •  Mendapatkan konsultasi hukum secara online sesuai preferensi Anda — melalui chat, panggilan suara, atau panggilan video")
                .captionLexend(size: 14)
                .foregroundStyle(Color.gray700)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
              
              Text("  •  Mengakses layanan konsultasi hukum gratis dari advokat berlisensi")
                .captionLexend(size: 14)
                .foregroundStyle(Color.gray700)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
              
              Text("  •  Menerima respons yang empatik, profesional, dan berorientasi pada kebutuhan Anda")
                .captionLexend(size: 14)
                .foregroundStyle(Color.gray700)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            }
            
          }
          .onAppear {
            self.reader = proxy
          }
        }
        
        Spacer()
        
        VStack(alignment: .center) {
          HStack() {
            Text("Pilih Advokat")
              .foregroundStyle(Color.background)
              .titleLexend(size: 14)
          }
          .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
          .background(Color.primaryInfo700)
          .cornerRadius(8)
          .padding(.horizontal, 16)
          .onTapGesture {
            store.navigateToAdvocateList()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.white)
        .shadow(color: .gray100, radius: 2)
      }
    }
    .ignoresSafeArea(.keyboard)
  }
  
}

#Preview {
  KemenPPAView(store: .init())
}
