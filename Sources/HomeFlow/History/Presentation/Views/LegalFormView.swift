//
//  LegalFormView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 19/02/25.
//

import SwiftUI
import AprodhitKit

public struct LegalFormView: View {
  
  @ObservedObject var store: LegalFormStore
  
  public init(store: LegalFormStore) {
    self.store = store
  }
  
  public var body: some View {
    
    ZStack {
      
      ScrollView(.vertical, showsIndicators: false) {
        
        VStack(spacing: 0) {
          
          documentView()
          
          Divider()
            .background(Color.gray100)
            .frame(maxWidth: .infinity, maxHeight: 1)
          
          VStack(alignment: .leading, spacing: 8) {
            
            HStack {
              Text("Riwayat Dokumen")
                .foregroundStyle(Color.gray900)
                .titleLexend(size: 16)
                .frame(maxWidth: .infinity, alignment: .leading)
              
            }
            .padding(.bottom, 16)
            .padding(.leading, 16)
            
            if store.historyViewModels.isEmpty {
              Text("Anda belum memiliki riwayat dokumen. Dokumen yang pernah akan ditampilkan di sini.")
                .foregroundStyle(Color.gray500)
                .captionLexend(size: 14)
                .padding(.horizontal, 16)
              
            } else {
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
      
      BottomSheetView(isPresented: $store.isPresentBottomSheet) {
        LegalFormBottomSheetContentView()
      }
      
    }
    .ignoresSafeArea(edges: .all)
    .background(Color.gray050)
    
  }
  
  @ViewBuilder
  func documentView() -> some View {
    if store.activeViewModels.isEmpty {
      ZStack {
        Image("document_bg_image", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(maxWidth: .infinity, maxHeight: 72)
        
        HStack {
          Image("document", bundle: .module)
          
          VStack(alignment: .leading, spacing: 4) {
            Text("Buat Dokumen Hukum")
              .foregroundStyle(Color.primaryInfo700)
              .titleLexend(size: 16)
            
            Text("Solusi Dokumen Hukum Tanpa Ribet, Cepat, dan Terjamin Keabsahannya")
              .foregroundStyle(Color.primaryInfo700)
              .captionLexend(size: 12)
              .padding(.top, 2)
          }
          
          Image(systemName: "chevron.right")
            .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
      }
      .cornerRadius(10)
      .shadow(color: Color.gray200, radius: 5)
      .padding(.all, 16)
      .padding(.top, 65)
      .onTapGesture {
        store.isPresentBottomSheet = true
      }
    } else {
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
    }
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
