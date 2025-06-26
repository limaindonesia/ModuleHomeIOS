//
//  ReasonToContinueConsultationView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit
import Combine

public struct ReasonToContinueConsultationView: View {
  
  public let arrayReasons: [ReasonEntity]
  @Binding var selectedReason: ReasonEntity?
  @Binding var reasonText: String
  private var onSendReason: (ReasonEntity) -> Void
  
  @State var didTapReject: Bool = false
  @State var didTapCancel: Bool = false
  @State var showTextView: Bool = false
  @State var enableButton: Bool = false
  @State var reasonTextErrorMessage: String = ""
  @State var isTextValid: Bool = true
  
  public init(
    arrayReasons: [ReasonEntity],
    selectedReason: Binding<ReasonEntity?>,
    reasonText: Binding<String>,
    onSendReason: @escaping (ReasonEntity) -> Void
  ) {
    self.arrayReasons = arrayReasons
    self._selectedReason = selectedReason
    self._reasonText = reasonText
    self.onSendReason = onSendReason
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          
          Text("Alasan Konsultasi Lanjutan")
            .titleLexend(size: 20)
          
          ForEach(0..<arrayReasons.count, id: \.self) { index in
            optionView(index)
              .padding(.leading, 2)
          }
          
          if showTextView {
            reasonTextView()
          }
          
          ButtonPrimary(
            title: "Pilih",
            color: enableButton
            ? Color.buttonActiveColor
            : Color.gray100,
            width: .infinity,
            height: 48
          ) {
            if enableButton {
              onSendReason(selectedReason!)
            }
          }
          
        }
        .padding(.vertical, 8)
      }
      .keyboardResponsive()
    }
    .padding(.horizontal, 16)
    .onAppear {
      chooseAnotherReason(selectedReason?.id)
    }
  }
  
  @ViewBuilder
  func reasonTextView() -> some View {
    VStack(alignment: .leading) {
      VStack {
        TextView(
          text: $reasonText,
          textStyle: .lexendFont(style: .caption(size: 12)),
          textColor: .darkTextColor,
          backgroundColor: selectedReason?.id == arrayReasons.last?.id ? .clear : .gray050
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              isTextValid ? Color.gray500 : Color.red,
              lineWidth: 2
            )
        )
        .onChange(of: reasonText) { newValue in
          isTextValid = isValidText(newValue)
          enableButton = enabledButtonOnlyWhenChoosingAnotherReason()
        }
      }
      .frame(maxWidth: .infinity, idealHeight: 88)
      .background(Color.gray050)
      .cornerRadius(6)
      
      if !isTextValid {
        Text("Mohon masukkan minimal 10 karakter")
          .foregroundColor(Color.danger500)
          .bodyLexend(size: 12)
          .padding(.bottom, 16)
      }
      
    }
  }
  
  @ViewBuilder
  func optionView(_ index: Int) -> some View {
    OptionView(
      text: arrayReasons[index].title,
      isSelected: selectedReason?.id == arrayReasons[index].id
    ) {
      withAnimation {
        selectedReason = arrayReasons[index]
        chooseAnotherReason(selectedReason?.id ?? 0)
        enableButton = enabledButtonOnlyWhenChoosingAnotherReason()
      }
      
      if index == arrayReasons.count - 1 {
        withAnimation {
          resetReasonText()
        }
      }
      
    }
    
  }
  
  public func resetReasonText() {
    isTextValid = true
  }
  
  private func enabledButtonOnlyWhenChoosingAnotherReason() -> Bool {
    if selectedReason?.id == arrayReasons.last?.id {
      return !reasonText.isEmpty && reasonText.count >= 10
    }
    
    return true
  }
  
  public func isValidText(_ text: String) -> Bool {
    return text.count > 10
  }
  
  public func chooseAnotherReason(_ id: Int?) {
    showTextView = id == arrayReasons.last?.id
    reasonText = id == arrayReasons.last?.id ? reasonText : ""
  }
  
}

#Preview {
  ReasonToContinueConsultationView(
    arrayReasons: [
      ReasonEntity(id: 1, title: "Adanya Perkembangan Kasus / Bukti Tambahan"),
      ReasonEntity(id: 2, title: "Membutuhkan Pendapat Lain"),
      ReasonEntity(id: 3, title: "Membutuhkan Pendapat Lain"),
      ReasonEntity(id: 4, title: "Lainnya")
    ],
    selectedReason: .constant(nil),
    reasonText: .constant(""),
    onSendReason: { _ in }
  )
}
