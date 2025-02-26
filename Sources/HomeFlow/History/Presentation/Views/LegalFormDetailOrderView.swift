//
//  LegalFormDetailOrderView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 21/02/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct LegalFormDetailOrderView: View {
  
  public init() {
    
  }
  
  public var body: some View {
    
    ScrollView {
      
      VStack(alignment: .leading) {
        
        HStack(alignment: .center) {
          VStack(alignment: .leading) {
            Text("Penilaian Anda")
              .titleLexend(size: 14)
            
            Text("Dinilai pada 30 Februari 2023, 14.17")
              .foregroundStyle(Color.gray400)
              .captionLexend(size: 10)
          }
          
          Spacer()
          
          StarRatingView(rating: 3)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
        }
        
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
        
        VStack(alignment: .leading, spacing: 12) {
          Text("Nilai Pengalaman Anda")
            .titleLexend(size: 14)
          
          VStack(alignment: .leading) {
            HStack(alignment: .top){
              Image("info", bundle: .module)
              Text("Ulasan Anda membantu Perqara meningkatkan layanan pembuatan dokumen.")
                .foregroundStyle(Color.warning900)
                .captionLexend(size: 14)
            }
            
            ButtonSecondary(
              title: "Beri Ulasan",
              backgroundColor: .clear,
              tintColor: .buttonActiveColor,
              width: .infinity,
              height: 32
            ) {
              
            }
          }
          .padding(.all, 8)
          .background(Color.warning050)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
        }
        
        VStack(spacing: 12) {
          
          HStack {
            
            Text("Rincian Pembayaran")
              .foregroundStyle(Color.darkTextColor)
              .titleLexend(size: 14)
            
            Spacer()
            
            Button {
              
            } label: {
              Text("Lihat Invoice")
                .foregroundStyle(Color.buttonActiveColor)
                .titleLexend(size: 14)
            }
            
          }
          
          FeeRowView(name: "Biaya Dokumen Hukum", amount: "Rp5.000") {
            
          }
          
          FeeRowView(name: "Biaya Layanan", amount: "Rp5.000", showInfo: true) {
            
          }
          
          FeeRowView(name: "Diskon Perqara", amount: "Rp5.000") {
            
          }
          
          Divider()
            .background(Color.gray100)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.horizontal, 8)
          
          HStack {
            
            Text("Total Pembayaran")
              .foregroundStyle(Color.darkTextColor)
              .titleLexend(size: 14)
            
            Spacer()
            
            Text("Rp1.000.000")
              .foregroundStyle(Color.darkTextColor)
              .titleLexend(size: 14)
            
          }
          
          HStack {
            
            Text("Metode Pembayaran")
              .foregroundStyle(Color.darkTextColor)
              .bodyLexend(size: 14)
            
            Spacer()
            
            Text("BCA Virtual Account")
              .foregroundStyle(Color.darkTextColor)
              .captionLexend(size: 14)
            
          }
          
          HStack {
            
            Text("Status Pembayaran")
              .foregroundStyle(Color.darkTextColor)
              .bodyLexend(size: 14)
            
            Spacer()
            
            Text("Berhasil")
              .foregroundStyle(Color.darkTextColor)
              .captionLexend(size: 14)
          }
          
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
        }
        
      }
      .padding(.horizontal, 16)
      
    }
    
  }
  
}

#Preview {
  LegalFormDetailOrderView()
}
