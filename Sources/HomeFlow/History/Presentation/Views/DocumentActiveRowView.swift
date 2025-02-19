//
//  DocumentActiveRowView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

public struct DocumentActiveRowView: View {
  
  public let viewModel: DocumentActiveViewModel
  
  public  init(viewModel: DocumentActiveViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    
    VStack(alignment: .leading) {
      
      HStack {
        Text(viewModel.status.rawValue)
          .foregroundStyle(Color.warning600)
          .captionLexend(size: 10)
          .padding(.horizontal, 6)
          .padding(.vertical, 4)
          .background(Color.warning100)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        
        Spacer()
        
        HStack(spacing: 0) {
          
          timerView(
            showTimeRemainig: true,
            paymentTimeRemaining: viewModel.timeRemaining
          )
          
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
        Image("ic_legal_form", bundle: .module)
        
        VStack(alignment: .leading) {
          Text(viewModel.title)
            .foregroundStyle(Color.darkTextColor)
            .titleLexend(size: 14)
          
          HStack {
            Text(viewModel.price)
              .foregroundStyle(Color.gray700)
              .titleLexend(size: 14)
            
            Spacer()
            
            ButtonPrimary(
              title: Constant.Text.GOTO_PAYMENT,
              color: Color.buttonActiveColor,
              width: 120,
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
    .shadow(color: Color.gray200, radius: 8)
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func timerView(
    showTimeRemainig: Bool,
    paymentTimeRemaining: TimeInterval
  ) -> some View {
    
    HStack(spacing: 2) {
      Image("ic_order_service_clock", bundle: .module)
        .renderingMode(.template)
        .foregroundStyle(Color.white)
      
      if showTimeRemainig {
        TimerTextView(paymentTimeRemaining: paymentTimeRemaining) { newValue in
          
        } onTimerTimeUp: {
          
        }
      }
      
    }
    .padding(.all, 4)
    .background(Color.warning500)
    .cornerRadius(5)
  }
  
}

#Preview {
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
}
