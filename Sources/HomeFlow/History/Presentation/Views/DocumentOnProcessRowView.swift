//
//  DocumentOnProcessRowView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

public struct DocumentOnProcessRowView: View {
  
  public let viewModel: DocumentOnProcessViewModel
  
  public  init(viewModel: DocumentOnProcessViewModel) {
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
              title: Constant.Text.NEXT,
              color: Color.buttonActiveColor,
              width: 85,
              height: 30
            ) {
              viewModel.onNext()
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
