//
//  ReasonToContinueConsultationView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct ReasonToContinueConsultationView: View {
  
  @ObservedObject public var store: ReasonToContinueStore
  private var onSendReason: (ReasonEntity, String) -> Void
  
  public init(
    store: ReasonToContinueStore,
    onSendReason: @escaping (ReasonEntity, String) -> Void
  ) {
    self.store = store
    self.onSendReason = onSendReason
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          
          Text("Alasan Konsultasi Lanjutan")
            .titleLexend(size: 20)
          
          ForEach(0..<store.arrayReasons.count, id: \.self) { index in
            optionView(index)
              .padding(.leading, 2)
          }
          
          if store.showTextView {
            reasonTextView()
          }
          
          ButtonPrimary(
            title: "Pilih",
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
    .padding(.horizontal, 16)
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
      
      if !store.isTextValid {
        Text("*Minimal 10 Karakter")
          .foregroundColor(Color.danger500)
          .bodyLexend(size: 12)
          .padding(.bottom, 16)
      }
      
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
      
      if index == store.arrayReasons.count - 1 {
        store.resetReasonText()
      }
      
    }
    
  }
}

#Preview {
  ReasonToContinueConsultationView(
    store: ReasonToContinueStore(arrayReasons: []),
    onSendReason: { (entity, anotherReason) in
      
    }
  )
}
