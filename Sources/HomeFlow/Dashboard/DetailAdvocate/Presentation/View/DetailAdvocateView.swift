//
//  DetailAdvocateView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 21/03/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct DetailAdvocateView: View {
  
  @State var heightContainer: CGFloat = 0
  
  @State var chipsData = [
    ChipData(text: "Pidana", color: .gray050),
    ChipData(text: "Perdata", color: .gray050),
    ChipData(text: "Pertanahan", color: .gray050),
    ChipData(text: "Perkawinan & Perceraian", color: .gray050),
    ChipData(text: "Kepailitan", color: .gray050),
    ChipData(text: "Perpajakan", color: .gray050)
  ]
  
  var peradiLists = [
    "Solusi hukum terbaik",
    "Berpengalaman di bidang keahlian",
    "Keamanan dan kenyamanan",
    "Garansi kepuasan klien"
  ]
  
  var body: some View {
    
    ScrollView {
      
      VStack(alignment: .leading, spacing: 16) {
//        lawyerInfoView()
//          .padding(.horizontal, 16)
//        
//        Divider()
//          .background(Color.gray100)
//          .frame(height: 1)
//        
//        VStack(alignment: .leading, spacing: 16) {
//          Text("Keahlian Advokat Ini")
//            .titleLexend(size: 14)
//          
//          skillsTagView(chipsData, height: $heightContainer)
//          
//          VStack(alignment: .leading) {
//            HStack {
//              Image("ic_peradi", bundle: .module)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 112, height: 48)
//              
//              Spacer()
//              
//              Button {
//                
//              } label: {
//                Text("Apa itu peradi")
//                  .foregroundStyle(Color.primaryInfo700)
//                  .titleLexend(size: 14)
//              }
//            }
//            
//            HStack {
//              Image("medal-star", bundle: .module)
//              Text("Terverifikasi Oleh PERADI Indonesia")
//                .titleLexend(size: 14)
//            }
//            
//            ForEach(peradiLists, id: \.self) { item in
//              HStack {
//                Image("ic_order_service_selected", bundle: .module)
//                Text(item)
//                  .captionLexend(size: 14)
//              }
//            }
//            
//            Spacer()
//          }
//          .padding(.vertical, 8)
//          .padding(.horizontal, 16)
//          .frame(maxWidth: .infinity, maxHeight: 300)
//          .background(Color.primaryInfo050)
//          .clipShape(RoundedRectangle(cornerRadius: 8))
//          .overlay {
//            RoundedRectangle(cornerRadius: 8)
//              .stroke(Color.primary200, lineWidth: 1)
//          }
//        }
//        .padding(.horizontal, 16)
//        
//        Divider()
//          .background(Color.gray100)
//          .frame(height: 1)
//        
//        Text("Pendidikan Terakhir")
//          .titleLexend(size: 14)
//          .padding(.horizontal, 16)
//        
//        Text("Fakultas Hukum Universitas Pelita Harapan")
//          .captionLexend(size: 14)
//          .padding(.horizontal, 16)
//        
//        Divider()
//          .background(Color.gray100)
//          .frame(height: 1)
//        
//        Text("Tentang Advokat")
//          .titleLexend(size: 14)
//          .padding(.horizontal, 16)
//        
//        Text("Suhendra Asido Hutabarat, S.H., S.E., M.H., M.M merupakan Ketua Pusat Bantuan Hukum (PBH) PERADI Manado, Ketua Yayasan Cahaya Mercusuar Indonesia, serta Direktur Kantor Hukum MGD.")
//          .captionLexend(size: 14)
//          .padding(.horizontal, 16)
//        
//        Divider()
//          .background(Color.gray100)
//          .frame(height: 1)
        
        reviewView()
          .padding(.horizontal, 16)
      }
      
    }
    
  }
  
  @ViewBuilder
  func lawyerInfoView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      
      HStack(alignment: .top) {
        RoundedAvatarImageView(
          nil,
          width: 80,
          height: 120
        )
        
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: 4) {
            HStack {
              Image("record-circle", bundle: .module)
              Text("Online")
                .captionLexend(size: 10)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.success050)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack(spacing: 3) {
              Image("ic_video", bundle: .module)
              Text("Tersedia")
                .foregroundStyle(Color.white)
                .captionLexend(size: 10)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
              LinearGradient(
                colors: [Color.gradient4, Color.gradient3],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
          }
          .padding(.bottom, 8)
          
          Text("Laili Amalia Puteri, S.H.")
            .titleLexend(size: 16)
            .padding(.bottom, 4)
          
          Text("Peradi")
            .captionLexend(size: 12)
          
          VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 4) {
              Image("location", bundle: .module)
              Text("Jakarta Utara")
                .captionLexend(size: 14)
            }
            
            HStack(spacing: 4) {
              Image("briefcase", bundle: .module)
              Text("15 Tahun")
                .captionLexend(size: 14)
            }
          }
          .padding(.top, 12)
        }
      }
      
      HStack(alignment: .center, spacing: 0) {
        Image("ic_star", bundle: .module)
          .padding(.trailing, 5)
        
        Text("4.0")
          .titleLexend(size: 16)
        
        Text("/5")
          .captionLexend(size: 12)
          .padding(.trailing, 12)
          .padding(.top, 4)
        
        Divider()
          .frame(width: 1)
          .background(Color.gray200)
        
        Text("32 Ulasan")
          .captionLexend(size: 12)
          .padding(.horizontal, 12)
        
        Spacer()
        
        Image("ic_right_arrow", bundle: .module)
      }
      .padding(.all, 8)
      .background(Color.gray050)
      .frame(height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  func skillsTagView(_ data: [ChipData], height: Binding<CGFloat>) -> some View {
    FlowLayout(data, height: height) { tag in
      ChipView(
        text: tag.text,
        textColor: .gray600,
        backgroundColor: .gray100,
        paddingVertical: 6,
        paddingHorizontal: 8
      )
    }
  }
  
  @ViewBuilder
  func reviewView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 0){
        Image("ic_star", bundle: .module)
          .padding(.trailing, 5)
        
        Text("4.0")
          .titleLexend(size: 16)
        
        Text("/5")
          .captionLexend(size: 12)
          .padding(.trailing, 12)
          .padding(.top, 4)
        
        Spacer()
        
        Text("1 April 2023")
          .captionLexend(size: 10)
      }
      
      TagView(
        text: "Pidana",
        color: .gray100,
        textColor: .gray600
      )
      
      Text("G*****")
        .bodyLexend(size: 12)
      
      Text("Konsultasi dengan Advokat ini sangat informatif dan membantu. Dia dengan cepat memahami situasi saya dan ...")
        .captionLexend(size: 12)
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    
    .background(Color.gray050)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray100, lineWidth: 1)
    }
    
  }
  
}

#Preview {
  DetailAdvocateView()
}

struct ChipView: View {
  
  private let text: String
  private let textColor: Color
  private let backgroundColor: Color
  private let paddingVertical: CGFloat
  private let paddingHorizontal: CGFloat
  
  init(
    text: String,
    textColor: Color,
    backgroundColor: Color,
    paddingVertical: CGFloat = 5,
    paddingHorizontal: CGFloat = 8
  ) {
    self.text = text
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.paddingVertical = paddingVertical
    self.paddingHorizontal = paddingHorizontal
  }
  
  var body: some View {
    Text(text)
      .foregroundColor(.gray600)
      .titleLexend(size: 14)
      .padding(.vertical, paddingVertical)
      .padding(.horizontal, paddingHorizontal)
      .background(Color.gray100)
      .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
