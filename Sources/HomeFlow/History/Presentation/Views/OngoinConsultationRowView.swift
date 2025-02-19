//
//  OngoinConsultationView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

public struct OngoinConsultationRowView: View {
  
  private let viewModel: OngoingConsultationViewModel
  
  public init(viewModel: OngoingConsultationViewModel) {
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
        
        HStack(spacing: 0) {
          Image("ic_order_service_clock", bundle: .module)
            .renderingMode(.template)
            .foregroundStyle(Color.gray600)
            .padding(.trailing, 4)
          
          TimerTextView(
            paymentTimeRemaining: viewModel.timeRemaining,
            textColor: Color.gray900
          ) { time in
            
          } onTimerTimeUp: {
            
          }
          
          Image("ic_right_arrow", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .padding(.leading, 8)
        }
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
            
            ButtonPrimary(
              title: Constant.Home.Text.BACK_TO_CONSULTATION,
              color: Color.buttonActiveColor,
              width: 158,
              height: 30
            ) {
              
            }
          }
          .padding(.vertical, 8)
        }
        
      }
    }
    .padding(.horizontal, 8)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .padding(.horizontal, 16)
    
  }
}

#Preview {
  OngoinConsultationRowView(
    viewModel: .init(
      name: "Illian Deta Arta Sari, S.H., MPPM.",
      imageURL: nil,
      type: .INCOMING,
      status: .ONGOING,
      timeRemaining: 190,
      issues: "Pidana",
      serviceName: "Probono(Chat Saja)",
      price: "Rp190.000",
      backToConsultation: {
        
      }
    )
  ).background(Color.success100)
}
