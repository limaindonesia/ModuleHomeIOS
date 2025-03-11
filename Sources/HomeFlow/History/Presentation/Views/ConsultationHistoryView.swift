//
//  ConsultationHistoryView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/02/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct ConsultationHistoryView: View {
  
  @ObservedObject var store: ConsultationHistoryStore
  
  public init(store: ConsultationHistoryStore) {
    self.store = store
  }
  
  public var body: some View {
    if store.showNotSignedInStatus {
      VStack(alignment: .center, spacing: 16) {
        Text("Anda harus masuk terlebih dahulu")
          .captionLexend(size: 14)
        
        ButtonPrimary(
          title: "Masuk",
          color: .buttonActiveColor,
          width: 150,
          height: 32
        ) {
          store.navigateToLogin()
        }
      }
    } else {
      ScrollView(.vertical, showsIndicators: false) {
        
        VStack(spacing: 0) {
          
          createActiveView()
          
          Divider()
            .background(Color.gray100)
            .frame(maxWidth: .infinity, maxHeight: 1)
          
          createHistoryView()
          
        }
        .padding(.bottom, 60)
        .onAppear {
          Task {
            await store.fetchUserSessionData()
            await store.fetchHistoryConsultations()
            await store.fetchActiveConsultations()
          }
          store.didBack()
        }
        
      }
      .ignoresSafeArea(.all)
      .background(Color.gray050)
    }
  }
  
  @ViewBuilder
  func createActiveView() -> some View {
    if store.activeConsultationViewModels.isEmpty {
      ZStack {
        Image("document_bg_image", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(maxWidth: .infinity, maxHeight: 72)
        
        HStack {
          Image("document", bundle: .module)
          
          VStack(alignment: .leading, spacing: 4) {
            Text("Belum ada konsultasi aktif")
              .foregroundStyle(Color.primaryInfo700)
              .titleLexend(size: 16)
            
            Text("Yuk temukan advokat terbaik Perqara  dan mulai konsultasi hukum")
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
        store.naviagteToAdvocateListing()
      }
    } else {
      VStack(alignment: .leading, spacing: 8) {
        Text("Konsultasi Aktif")
          .foregroundStyle(Color.gray900)
          .titleLexend(size: 16)
          .padding(.bottom, 16)
          .padding(.leading, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        ForEach(store.activeConsultationViewModels, id: \.id) { model in
          OngoinConsultationRowView(viewModel: model)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(Color.success100)
      .padding(.top, 65)
    }
  }
  
  @ViewBuilder
  private func createHistoryView() -> some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      
      HStack {
        Text("Riwayat Konsultasi")
          .foregroundStyle(Color.gray900)
          .titleLexend(size: 16)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
          Text("Semua Status")
            .captionLexend(size: 14)
          
          Image("ic_arrow_down", bundle: .module)
        }
        .padding(.all, 8)
        .background(Color.clear)
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray200, lineWidth: 1)
        }
        
      }
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      
      ForEach(store.historyViewModels, id: \.id) { model in
        HistoryConsultationRowView(viewModel: model)
          .onAppear{
            Task {
              await store.loadMoreContentIfNeeded(currentItem: model)
            }
          }
//        HistoryConsultationRowView(
//          viewModel: .init(
//            name: model.name,
//            imageURL: model.imageURL,
//            type: .HISTORY,
//            status: model.status,
//            serviceName: model.serviceName,
//            date: model.dateStr(),
//            issues: model.issues,
//            price: model.price,
//            readSummaries: {
//              
//            },
//            onTap: {
//              self.store.navigateToDetailHistory()
//            }
//          )
//        )
//        .onAppear{
//          Task {
//            await store.loadMoreContentIfNeeded(currentItem: model)
//          }
//        }
      }
      
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
  }
  
}

#Preview {
  ConsultationHistoryView(
    store: ConsultationHistoryStore(
      userSessionDataSource: MockUserSessionDataSource(),
      consultationRepository: MockConsultationHistoryRepository(),
      advocateNavigator: MockNavigator(),
      loginNavigator: MockNavigator(),
      consultationNavigator: MockNavigator()
    )
  )
}
