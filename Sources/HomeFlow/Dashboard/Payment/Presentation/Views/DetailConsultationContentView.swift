//
//  DetailConsultationContentView.swift
//
//
//  Created by Muhammad Yusuf on 24/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct DetailConsultationContentView: View {
  
  private var category: String
  private var duration: String
  private var type: String
  private var desc: String

  init(
    category: String,
    duration: String,
    type: String,
    desc: String
  ) {
    self.category = category
    self.duration = duration
    self.type = type
    self.desc = desc
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Text("Detail Konsultasi")
        .foregroundColor(Color.black)
        .titleLexend(size: 16)
        .padding(.horizontal, 16)
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(.horizontal, 16)
      
      ScrollView(showsIndicators: true) {
        HStack(spacing: 16) {
          HStack(spacing: 16) {
            Text("Kategori")
              .foregroundColor(Color.gray700)
              .captionLexend(size: 14)
            
            Spacer()
            
            Text(category)
              .foregroundColor(Color.primaryInfo600)
              .titleLexend(size: 14)
          }
          .padding(.horizontal, 16)
          .frame(
            maxWidth: .infinity,
            minHeight: 18,
            alignment: .leading
            )
        }
        .padding(.vertical, 2)
        
        HStack(spacing: 16) {
          HStack(spacing: 16) {
            Text("Konsultasi")
              .foregroundColor(Color.gray700)
              .captionLexend(size: 14)
            
            Spacer()
            
            Text(type)
              .foregroundColor(Color.primaryInfo600)
              .titleLexend(size: 14)
          }
          .padding(.horizontal, 16)
          .frame(
            maxWidth: .infinity,
            minHeight: 18,
            alignment: .leading
            )
        }
        .padding(.vertical, 2)
        
        HStack(spacing: 16) {
          HStack(spacing: 16) {
            Text("Durasi konsultasi")
              .foregroundColor(Color.gray700)
              .captionLexend(size: 14)
            
            Spacer()
            
            Image("ic_order_service_clock", bundle: .module)
              .resizable()
              .frame(width: 16, height: 16)
              .padding(.horizontal, 0)
            
            Text(duration)
              .foregroundColor(Color.primaryInfo600)
              .titleLexend(size: 14)
          }
          .padding(.horizontal, 16)
          .frame(
            maxWidth: .infinity,
            minHeight: 18,
            alignment: .leading
            )
        }
        .padding(.vertical, 0)
        
        Text(desc)
          .foregroundColor(Color.gray700)
          .captionLexend(size: 14)
          .padding(.horizontal, 16)
          .padding(.top, 16)
          .frame(
            maxWidth: .infinity,
            minHeight: 18,
            alignment: .leading
            )
        
      }
    }
    .padding(.horizontal, 16)
  }
  
}

#Preview {
  DetailConsultationContentView(
    category: "Pidana",
    duration: "60 Menit",
    type: "Chat + Voice + Video Call",
    desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
  )
  
}


