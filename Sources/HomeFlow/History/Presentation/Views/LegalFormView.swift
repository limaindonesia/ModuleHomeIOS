//
//  LegalFormView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI

public struct LegalFormView: View {
  
  @ObservedObject var store: LegalFormStore
  
  public init(store: LegalFormStore) {
    self.store = store
  }
  
  public var body: some View {
    
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(spacing: 0) {
        
        VStack(alignment: .leading, spacing: 8) {
          
          Text("Dokumen Aktif")
            .foregroundStyle(Color.gray900)
            .titleLexend(size: 16)
            .padding(.bottom, 8)
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          ForEach(store.activeViewModels, id: \.id) { model in
            activeDocument(model)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.success100)
        .padding(.top, 65)
        
        VStack(alignment: .leading, spacing: 8) {
          
          HStack {
            Text("Riwayat Dokumen")
              .foregroundStyle(Color.gray900)
              .titleLexend(size: 16)
              .frame(maxWidth: .infinity, alignment: .leading)
            
          }
          .padding(.bottom, 16)
          .padding(.leading, 16)
          
          ForEach(store.historyViewModels, id: \.id) { model in
            
            if let historyModel = model as? DocumentHistoryViewModel {
              DocumentHistoryRowView(
                viewModel: .init(
                  type: model.type,
                  title: historyModel.title,
                  status: historyModel.status,
                  date: historyModel.dateStr(),
                  price: historyModel.price,
                  onNext: {
                    historyModel.onNext()
                  }
                )
              )
            }
            
          }
          
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        
      }
      .padding(.bottom, 24)
      .onAppear {
        Task {
          await store.fetchDocuments()
        }
      }
      
    }
    .ignoresSafeArea(edges: .all)
    .background(Color.gray050)
    
  }
  
  @ViewBuilder
  func activeDocument(_ model: DocumentBaseViewModel) -> some View {
    
    if let waitingForPaymentModel = model as? DocumentActiveViewModel {
      DocumentActiveRowView(
        viewModel: .init(
          type: model.type,
          title: waitingForPaymentModel.title,
          status: waitingForPaymentModel.status,
          timeRemaining: waitingForPaymentModel.timeRemaining,
          price: waitingForPaymentModel.price,
          onPayment: {
            waitingForPaymentModel.onPayment()
          }
        )
      )
    }
    
    if let processModel = model as? DocumentOnProcessViewModel {
      DocumentOnProcessRowView(
        viewModel: .init(
          type: model.type,
          title: processModel.title,
          status: processModel.status,
          date: processModel.dateStr(),
          price: processModel.price,
          onNext: {
            processModel.onNext()
          }
        )
      )
    }
    
  }
  
}

#Preview {
  LegalFormView(
    store: LegalFormStore(
      legalFormRepository: MockLegalFormRepository()
    )
  )
}
