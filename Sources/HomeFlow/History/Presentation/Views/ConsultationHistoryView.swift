//
//  ConsultationHistoryView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import SwiftUI

public struct ConsultationHistoryView: View {
  
  public var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(spacing: 0) {
        
        VStack(alignment: .leading, spacing: 8) {
          
          Text("Konsultasi Aktif")
            .foregroundStyle(Color.gray900)
            .titleLexend(size: 16)
            .padding(.bottom, 16)
            .padding(.leading, 16)
          
          OngoinConsultationRowView(
            viewModel: .init(
              name: "Illian Deta Arta Sari Ayu Mustika Ratu, S.H., MPPM.",
              imageURL: nil,
              type: .INCOMING,
              status: .ONGOING,
              timeRemaining: 190,
              issues: "Pidana",
              serviceName: "Probono Chat Saja",
              price: "Rp190.000",
              backToConsultation: {
                
              }
            )
          )
          
        }
        .padding(.vertical, 16)
        .background(Color.success100)
        .padding(.top, 65)
        
        VStack(alignment: .leading, spacing: 0) {
          
          HStack {
            Text("Riwayat Konsultasi")
              .foregroundStyle(Color.gray900)
              .titleLexend(size: 16)
            
          }
          .padding(.bottom, 16)
          .padding(.leading, 16)
          
          HistoryConsultationRowView(
            viewModel: .init(
              name: "Illian Deta Arta Sari Ayu Mustika Ratu, S.H., MPPM.",
              imageURL: nil,
              type: .HISTORY,
              status: .DONE,
              serviceName: "Probono(Chat Saja)",
              date: "",
              issues: "Pidana",
              price: "Rp1.000.000",
              readSummaries: {
                
              }
            )
          )
          
        }
        .padding(.vertical, 16)
        
      }
      
    }
    .ignoresSafeArea(.all)
    .background(Color.gray050)
    
  }
  
}

#Preview {
  ConsultationHistoryView()
}
