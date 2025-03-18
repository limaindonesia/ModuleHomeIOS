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
  
  @ObservedObject var store: LegalFormDetailOrderStore
  
  public init(store: LegalFormDetailOrderStore) {
    self.store = store
  }
  
  public var body: some View {
    
    GeometryReader { geometry in
      
      ZStack(alignment: .top) {
        
        Color.white.ignoresSafeArea()
        
        VStack(spacing: 0) {
          
          StandardHeaderView(title: "Detail Pesanan") {
            store.didBack()
          }
          .frame(height: 60)
          .background(Color.white)
          .zIndex(1)
          
          ScrollView {
            VStack {
              
              if store.showRating {
                ratingView()
              }
              
              orderDetailView()
              
              if store.showSummary {
                summaryView()
              }
              
              paymentDetailsView()
              
              Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .frame(minHeight: geometry.size.height - 70)
          }
          .frame(width: screen.width, height: screen.height)
        }
        .background(Color.gray050)
        
        BottomSheetView(isPresented: $store.isPresentRatingBottomSheet) {
          SubmitRatingBottomContentView()
            .padding(.bottom, 80)
        }
      }
      .onAppear {
        Task {
          await store.fetchUserSessionData()
          await store.fetchDocumentBy(id: store.entity.legalFormID)
          store.readStatus()
        }
      }
      
    }
    .background(Color.white)
  }
  
  @ViewBuilder
  private func ratingView() -> some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading) {
          Text("Penilaian Anda").titleLexend(size: 14)
          Text("Dinilai pada 30 Februari 2023, 14.17").foregroundStyle(Color.gray400).captionLexend(size: 10)
        }
        Spacer()
        StarRatingView(rating: store.entity.rating)
      }
      .padding()
      .background(Color.white)
      .overlay{
        RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
      }
    }
  }
  
  @ViewBuilder
  private func orderDetailView() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image("ic_legal_form", bundle: .module)
        
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(store.entity.orderNumber).captionLexend(size: 12)
            Spacer()
            Text(store.entity.status.rawValue)
              .foregroundStyle(Color.warning600)
              .titleLexend(size: 10)
              .padding(.horizontal, 6)
              .padding(.vertical, 4)
              .background(Color.warning100)
              .cornerRadius(10)
          }
          
          Text(store.entity.title)
            .titleLexend(size: 14)
          
          Text(store.entity.getDateString())
            .captionLexend(size: 12)
        }
      }
      
      Divider().background(Color.gray100)
      
      ButtonPrimary(
        title: store.buttonViewModel.title,
        color: .buttonActiveColor,
        width: .infinity,
        height: 40
      ) {
        store.buttonViewModel.onTap()
      }
    }
    .padding()
    .background(Color.white)
    .overlay{
      RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
    }
  }
  
  @ViewBuilder
  private func summaryView() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Nilai Pengalaman Anda")
        .titleLexend(size: 14)
      
      VStack(alignment: .leading) {
        HStack {
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
          store.isPresentRatingBottomSheet = true
        }
      }
      .padding()
      .background(Color.warning050)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding()
    .background(Color.white)
    .overlay{
      RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
    }
  }
  
  @ViewBuilder
  private func paymentDetailsView() -> some View {
    VStack(spacing: 12) {
      HStack {
        Text("Rincian Pembayaran")
          .titleLexend(size: 14)
        Spacer()
        Button {
          
        } label: {
          Text("Lihat Invoice")
          .titleLexend(size: 14)
          .foregroundStyle(Color.buttonActiveColor)
        }
      }
      
      FeeRowView(
        name: store.entity.legalFormFee.name,
        amount: store.entity.legalFormFee.amount
      ) { }
      
      FeeRowView(
        name: store.entity.adminFee.name,
        amount: store.entity.adminFee.amount
      ) { }
      
      FeeRowView(
        name: store.entity.discount.name,
        amount: store.entity.adminFee.amount
      ) { }
      
      Divider().background(Color.gray100).padding(.horizontal, 8)
      
      HStack {
        Text("Total Pembayaran")
          .titleLexend(size: 14)
        Spacer()
        Text(store.entity.totalAmount)
          .titleLexend(size: 14)
      }
      
      HStack {
        Text("Metode Pembayaran")
          .bodyLexend(size: 14)
        Spacer()
        Text(store.entity.paymentMethod)
          .captionLexend(size: 14)
      }
      
      HStack {
        Text("Status Pembayaran")
          .bodyLexend(size: 14)
        Spacer()
        Text(store.entity.paymentStatus)
          .captionLexend(size: 14)
      }
    }
    .padding()
    .background(Color.white)
    .overlay{
      RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
    }
  }
}

#Preview {
  LegalFormDetailOrderView(
    store: LegalFormDetailOrderStore(
      entity: .init(),
      userSessionDataSource: MockUserSessionDataSource(),
      legalFormRepository: MockLegalFormRepository(),
      legalFormNavigator: MockLegalFormNavigator()
    )
  )
}
