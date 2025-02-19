//
//  HistoryConsultationRowView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

public struct HistoryConsultationRowView: View {
  private let viewModel: HistoryConsultationViewModel
  
  public init(viewModel: HistoryConsultationViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      
      HStack {
        Text(viewModel.status.rawValue)
          .foregroundStyle(Color.success900)
          .captionLexend(size: 10)
          .padding(.horizontal, 6)
          .padding(.vertical, 4)
          .background(Color.success100)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        
        Spacer()
        
        Text(viewModel.dateStr())
          .foregroundStyle(Color.gray900)
          .captionLexend(size: 12)
      }
      .padding(.top, 8)
      
      Divider()
        .background(Color.gray100)
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(.vertical, 8)
      
      HStack(alignment: .top) {
        Image(systemName: "person.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 56, height: 84)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay {
            RoundedRectangle(cornerRadius: 8).stroke(
              Color.gray100,
              lineWidth: 1
            )
          }
        
        VStack(alignment: .leading) {
          Text(viewModel.name)
            .foregroundStyle(Color.darkTextColor)
            .titleLexend(size: 14)
          
          HStack {
            TagView(
              text: viewModel.issues,
              color: Color.primaryInfo100,
              textColor: Color.primaryInfo600
            )
            
            TagView(
              text: viewModel.serviceName,
              color: Color.gray100,
              textColor: Color.darkTextColor
            )
          }
          
          HStack {
            Text(viewModel.price)
              .foregroundStyle(Color.gray700)
              .titleLexend(size: 14)
            
            Spacer()
            
            Button {
              viewModel.readSummaries()
            } label: {
              Text("Baca Ringkasan")
                .foregroundStyle(Color.primaryInfo700)
                .titleLexend(size: 14)
            }

          }
          .padding(.vertical, 8)
        }
        
      }
    }
    .padding(.horizontal, 8)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: Color.gray200, radius: 8)
    .padding(.horizontal, 16)
    
  }
}

#Preview {
  HistoryConsultationRowView(
    viewModel: .init(
      name: "Illian Deta Arta Sari, S.H., MPPM.",
      imageURL: nil,
      type: .INCOMING,
      status: .DONE,
      serviceName: "Probono(Chat Saja)",
      date: "",
      issues: "Pidana",
      price: "Rp190.000",
      readSummaries: {
        
      }
    )
  )
}
