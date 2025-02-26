//
//  LegalFormPaymentCheckView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 26/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct LegalFormPaymentCheckView: View {
  
  @ObservedObject var store: PaymentCheckStore
  
  var body: some View {
    ZStack {
      VStack(spacing: 12) {
        infoDetailView()
          .padding(.top, 16)
        
        actionView()
        
        Spacer()
      }
      
      BottomSheetView(
        isPresented: $store.isPresentReasonBottomSheet,
        dismissable: true
      ) {
        CancelationReasonContentView(
          store: CancelationReasonStore(
            arrayReasons: store.reasons
          ),
          imageURL: store.lawyerInfo.imageURL,
          lawyerName: store.lawyerInfo.name,
          onSendReason: { (entity, reason) in
            store.selectedReason = entity
            store.reason = reason
            Task {
              await store.requestCancelation()
            }
            
            GLogger(
              .info,
              layer: "Presentation",
              message: "send reason \(entity.id) : \( entity.title) : \(reason)"
            )
          }
        )
        
      } onDismissed: {
        Task {
          await store.onDismissedReasonBottomSheet()
        }
      }
    }
    .background(Color.gray100)
  }
  
  @ViewBuilder
  func infoDetailView() -> some View {
    VStack(spacing: 12) {
      HStack {
        Text("Harap selesaikan pembayaran Konsultasi Instan dalam:")
          .foregroundStyle(Color.warning900)
          .titleLexend(size: 12)
        
        Spacer()
        
        HStack(spacing: 3) {
          Image("ic_timer", bundle: .module)
            .renderingMode(.template)
            .foregroundStyle(.white)
          
          if store.showTimeRemainig {
            TimerTextView(paymentTimeRemaining: store.paymentTimeRemaining.value) { newValue in
              store.paymentTimeRemaining.value = newValue
            } onTimerTimeUp: {
              Task {
                await store.requestConsultationById()
              }
            }
          }
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(Color.warning500)
        .clipShape(RoundedRectangle(cornerRadius: 6))
      }
      .frame(maxWidth: .infinity, maxHeight: 48)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color.warning050)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      
      HStack(alignment: .center) {
        Text("OVO")
          .titleLexend(size: 14)
        
        Spacer()
        
        Image("ic_payment_ovo", bundle: .module)
      }
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
      
      HStack(alignment: .center) {
        VStack(alignment: .leading) {
          Text("Total Pembayaran")
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
          
          Text("Rp50.000")
            .titleLexend(size: 16)
        }
        
        Spacer()
        
        HStack {
          Image("", bundle: .module)
          Button {
            
          } label: {
            Text("Salin")
              .foregroundStyle(Color.primaryInfo700)
              .titleLexend(size: 14)
          }

        }
      }
      
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, minHeight: 100)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .padding(.horizontal, 12)
  }
  
  @ViewBuilder
  func actionView() -> some View {
    VStack(spacing: 12) {
      Text("Anda akan otomatis terhubung dengan advokat setelah pembayaran terverifikasi.")
        .foregroundStyle(Color.gray500)
        .multilineTextAlignment(.center)
        .bodyLexend(size: 14)
      
      ButtonPrimary(
        title: "Selesaikan Pembayaran",
        color: .primaryInfo700,
        width: .infinity,
        height: 48
      ) {
        store.navigateToPaymentGateway()
      }
      
      Button {
        store.showReasonBottomSheet()
      } label: {
        Text("Batalkan Pesanan")
          .foregroundStyle(Color.primaryInfo700)
          .titleLexend(size: 14)
      }
      
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, minHeight: 100)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .padding(.horizontal, 12)
  }
}

#Preview {
  LegalFormPaymentCheckView(store: PaymentCheckStore())
}
