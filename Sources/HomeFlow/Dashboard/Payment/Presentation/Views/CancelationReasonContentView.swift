//
//  CancelationReasonContentView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct CancelationReasonContentView: View {
  
  @ObservedObject private var store: CancelationReasonStore
  private var imageURL: URL?
  private var lawyerName: String
  private var onSendReason: (ReasonEntity, String) -> Void

  init(
    store: CancelationReasonStore,
    imageURL: URL?,
    lawyerName: String,
    onSendReason: @escaping (ReasonEntity, String) -> Void
  ) {
    self.store = store
    self.imageURL = imageURL
    self.lawyerName = lawyerName
    self.onSendReason = onSendReason
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          HStack(spacing: 10) {
            RoundedAvatarImageView(
              imageURL,
              width: 32,
              height: 32
            )
            
            Text(lawyerName)
              .bodyLexend(size: 14)
          }
          .padding(.horizontal, 8)
          .frame(
            maxWidth: .infinity,
            minHeight: 48,
            alignment: .leading
          )
          .background(Color.danger050)
          .clipShape(RoundedRectangle(cornerRadius: 4))
          
          Text("Kenapa Tidak Melanjutkan Proses?")
            .titleLexend(size: 20)
          
          Text("Beritahukan kami alasan anda, sehingga kami dapat memberikan layanan terbaik")
            .captionLexend(size: 14)
          
          ForEach(0..<store.arrayReasons.count, id: \.self) { index in
            optionView(index)
              .padding(.leading, 2)
          }
          
          if store.showTextView {
            reasonTextView()
          }
          
          ButtonPrimary(
            title: "Kirim",
            color: store.enableButton
            ? Color.buttonActiveColor
            : Color.gray100,
            width: .infinity,
            height: 48
          ) {
            if store.enableButton {
              onSendReason(
                store.arrayReasons[store.selectedIndex ?? 0],
                store.reasonText
              )
            }
          }
          
        }
        .padding(.vertical, 8)
      }
      .onAppear {
        store.selectedIndex = store.findSelectedIndex()
      }
      .keyboardResponsive()
    }
  }
  
  @ViewBuilder
  func reasonTextView() -> some View {
    VStack(alignment: .leading) {
      VStack {
        TextView(
          text: $store.reasonText,
          textStyle: .lexendFont(style: .caption(size: 12)),
          textColor: .darkTextColor,
          backgroundColor: store.selectedIndex == store.arrayReasons.last?.id ? .clear : .gray050
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              store.isTextValid ? Color.gray500 : Color.red,
              lineWidth: 2
            )
        )
      }
      .frame(maxWidth: .infinity, idealHeight: 88)
      .background(Color.gray050)
      .cornerRadius(6)
      
      Text("*Minimal 10 Karakter")
        .foregroundColor(store.isTextValid ? Color.gray500 : Color.danger500)
        .bodyLexend(size: 12)
        .padding(.bottom, 16)
    }
  }
  
  @ViewBuilder
  func optionView(_ index: Int) -> some View {
    OptionView(
      text: store.arrayReasons[index].title,
      isSelected: store.selectedIndex == index
    ) {
      store.selectedIndex = index
      store.selectedReason = store.arrayReasons[index]
    }
    
  }
  
}

#Preview {
  CancelationReasonContentView(
    store: CancelationReasonStore(
      arrayReasons: [
        ReasonEntity(id: 1, title: "Ingin melihat advokat lain"),
        ReasonEntity(id: 2, title: "Bidang keahlian advokat tidak sesuai dengan permasalahan saya"),
        ReasonEntity(id: 3, title: "Saya ingin mengganti deskripsi masalah"),
        ReasonEntity(id: 4, title: "Biaya konsultasi kurang sesuai anggaran saya"),
        ReasonEntity(id: 5, title: "Koneksi internet saya tidak stabil"),
        ReasonEntity(id: 6, title: "Saya tidak menemukan metode pembayaran yang sesuai"),
        ReasonEntity(id: 7, title: "Lainnya")
      ]
    ),
    imageURL: URL(string: ""),
    lawyerName: "Terry Hasibuan S.H",
    onSendReason: {  (_, _) in }
  )
  
  
}


