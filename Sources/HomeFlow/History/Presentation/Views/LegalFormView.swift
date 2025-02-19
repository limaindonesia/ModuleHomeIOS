//
//  LegalFormView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI

public struct LegalFormView: View {
  
  public init() {}
  
  public var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(spacing: 0) {
        
        VStack(alignment: .leading, spacing: 8) {
          
          Text("Dokumen Aktif")
            .foregroundStyle(Color.gray900)
            .titleLexend(size: 16)
            .padding(.bottom, 8)
            .padding(.leading, 16)
          
          DocumentActiveRowView(
            viewModel: .init(
              type: .ACTIVE,
              title: "Perjanjian Pinjam Meminjam (Utang Piutang)",
              status: .WAITING_FOR_PAYMENT,
              timeRemaining: 16000,
              price: "Rp60.000",
              onPayment: {
                
              }
            )
          )
          
          DocumentOnProcessRowView(
            viewModel: .init(
              type: .ACTIVE,
              title: "Surat Pernyataan Ahli Waris",
              status: .ON_PROCESS,
              date: "",
              price: "Rp60.000",
              onNext: {
                
              }
            )
          )
          
        }
        .padding(.vertical, 16)
        .background(Color.success100)
        .padding(.top, 65)
        
        VStack(alignment: .leading, spacing: 0) {
          
          HStack {
            Text("Riwayat Dokumen")
              .foregroundStyle(Color.gray900)
              .titleLexend(size: 16)
            
          }
          .padding(.bottom, 16)
          .padding(.leading, 16)
          
          DocumentHistoryRowView(
            viewModel: .init(
              type: .ACTIVE,
              title: "Surat Pernyataan Ahli Waris",
              status: .ON_PROCESS,
              date: "",
              price: "Rp60.000",
              onNext: {
                
              }
            )
          )
          
        }
        .padding(.vertical, 16)
      }
      
    }
    .ignoresSafeArea(edges: .all)
    .background(Color.gray050)
    
  }
}

#Preview {
  LegalFormView()
}
