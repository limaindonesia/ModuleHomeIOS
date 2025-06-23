//
//  OrderProcessKemenPPPA.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 16/06/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct OrderProcessKemenPPPAView: View {
  
  @ObservedObject var store: OrderProcessKemenPPPAStore
  @State private var reader: ScrollViewProxy?
  @FocusState var isFocused: Bool
  @StateObject private var keyboard = KeyboardObserver()
  
  var body: some View {
    ZStack {
      VStack {
        ScrollViewReader { proxy in
          ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
              lawyerInfoView(
                imageURL: store.lawyerInfoViewModel.imageURL,
                name: store.lawyerInfoViewModel.name,
                agency: store.lawyerInfoViewModel.agency,
                price: store.lawyerInfoViewModel.price,
                originalPrice: store.lawyerInfoViewModel.originalPrice,
                isDiscount: store.lawyerInfoViewModel.isDiscount,
                isProbono: store.lawyerInfoViewModel.isProbono,
                timeStr: store.timeConsultation
              )
              .padding(.horizontal, 16)
              
              explanationView()
                .padding(.horizontal, 16)
            }
            .padding(.bottom, keyboard.keyboardHeight)
            .padding(.vertical, 16)
            
          }
          .onAppear {
            self.reader = proxy
          }
        }
        
        Spacer()
        
        ButtonPrimary(
          title: "Lanjutkan Proses",
          color: .buttonActiveColor,
          width: .infinity,
          height: 40
        ) {
          store.requestToProcessKemenPPPA()
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.horizontal, 16)
      }
      .task {
        await store.fetchUserSession()
        await store.fetchProbonoStatus()
        await store.fetchReasonKemenPPPA()
        await store.fetchKemenPPPACategory()
        await store.fetchPrivacyPolicyKemenPPPA()
      }
      
      if store.isAIProcessing {
        Color.black.opacity(0.6)
          .zIndex(1)
        
        ShimmerText()
          .position(x: UIScreen.main.bounds.midX - 16, y: UIScreen.main.bounds.height / 2 - 200)
          .padding(.horizontal, 16)
          .zIndex(2)
      }
      
      BottomSheetView(isPresented: $store.isPresentError) {
        AIErrorBottomContentView(
          imageName: store.errorMessage.imageName,
          title: store.errorMessage.title,
          description: store.errorMessage.message,
          buttonText: store.errorMessage.buttonText,
          onTap: {
            store.hideErrorMessage()
          }
        )
      }
      
      BottomSheetView(
        isPresented: $store.isPresentUndismissableError,
        dismissable: false
      ) {
        AIUndismissableBottomContentView(
          imageName: store.errorMessage.imageName,
          title: store.errorMessage.title,
          description: store.errorMessage.message,
          onTapAdvocateLists: {
            store.navigateToAdvocateLists()
          },
          onTapBack: {
            store.navigateBack()
          }
        )
      }
      
      BottomSheetView(isPresented: $store.isPresentBottomSheet) {
        OrderInfoBottomSheetView(
          price: store.getPriceBottom()
        ) {
          store.navigateToPayment()
        }
      }
      
      BottomSheetView(isPresented: $store.isPresentChangeCategoryIssue) {
        PriceCategoryView(
          categoryPrices: store.priceCategories,
          categoryPricesNonSelected: store.getUnSelectedArray(),
          selectedID: store.getSelectedID(),
          lawyerInfo: store.lawyerInfoViewModel,
          onSelectCategory: { index in
            store.onTapChange(id: index)
          }
        )
        .padding(.horizontal, -16)
        .frame(height: store.getHeightChangeBottomSheet())
      }
      
      BottomSheetView(isPresented: $store.isPresentReasonToContinue) {
        ReasonToContinueConsultationView(
          arrayReasons: store.reasonsKemenPPPA,
          selectedReason: $store.selectedReason,
          reasonText: $store.reasonToContinueText,
          onSendReason: { entity in
            store.selectedReason = entity
            store.isPresentReasonToContinue = false
          }
        )
      }
      
      CustomBottomSheetView(isPresented: $store.isPresentViolenceBottomSheet) {
        ViolenceContentView(
          violences: store.violences,
          selected: store.selectedViolence,
          isPresent: $store.isPresentViolenceBottomSheet
        ) { violence in
          store.selectedViolence = violence
        }
      }
      
      CustomBottomSheetView(isPresented: $store.isPresentPrivacyKemenPPPA) {
        PrivacyPolicyKemenPPPAView(htmlText: store.htmlText) {
          store.isPresentPrivacyKemenPPPA = false
          Task {
            await store.createConsultation()
          }
        }
      }
    }
    .padding(.top, 3)
    .ignoresSafeArea(.keyboard)
    
  }
  
  @ViewBuilder
  func lawyerInfoView(
    imageURL: URL?,
    name: String,
    agency: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Bool,
    timeStr: String
  ) -> some View {
    HStack (spacing: 12) {
      CircleAvatarImageView(
        imageURL,
        width: 48,
        height: 48
      )
      .padding(.leading, 16)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(name)
          .titleLexend(size: 14)
          .lineLimit(2)
        
        HStack {
          Image("location", bundle: .module)
            .resizable()
            .frame(width: 12, height: 12)
          
          Text(store.lawyerInfoViewModel.location)
            .foregroundColor(.darkGray400)
            .bodyLexend(size: 12)
        }
        
        HStack {
          Image("medal-star", bundle: .module)
            .resizable()
            .frame(width: 12, height: 12)
          
          Text("Terverifikasi oleh Peradi")
            .foregroundColor(.primaryInfo600)
            .bodyLexend(size: 12)
        }
      }
      .padding(.top, 16)
      .padding(.bottom, 16)
      
      Spacer()
      
      Button {
        
      } label: {
        Image("ic_chevron_down", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.trailing, 8)
      }
      
    }
    .frame(maxWidth: .infinity, maxHeight: 80)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }
  
  @ViewBuilder
  func explanationView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      VStack {
        Text("Konsultasi 60 menit via chat atau panggilan suara/ video sesuai ketersediaan advokat")
          .captionLexend(size: 12)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity)
      .background(Color.primaryInfo050)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8).stroke(
          Color.primary200,
          lineWidth: 1
        )
      }
      .padding(.bottom, 8)
      
      Text("Tuliskan Deskripsi Masalah")
        .titleLexend(size: 16)
      
      Text("Mohon ceritakan masalah yang akan Anda konsultasikan")
        .captionLexend(size: 12)
      
      descriptionTextView()
        .coordinateSpace(name: "DESCRIPTION")
        .padding(.bottom)
      
      Divider()
        .frame(maxWidth: .infinity)
        .background(Color.gray200)
        .padding(.bottom)
      
      violenceOption()
        .padding(.bottom)
      
      if store.showReasonField {
        reasonToContinueConsultation()
          .padding(.bottom)
      }
      
      Divider()
        .frame(maxWidth: .infinity)
        .background(Color.gray200)
        .padding(.bottom)
      
      applicantOption()
        .padding(.bottom)
      
      PTextField(
        title: "Nomor Induk Kependudukan",
        placeHolder: "Nomor yang tertera di KTP/ KK",
        value: $store.identityNumber,
        errorMessage: $store.identityNumberErrorMessage
      )
      
      HStack {
        RoundedCheckBoxView(isSelected: store.didNotHaveIdentity) {
          store.didNotHaveIdentity.toggle()
        }
        
        Text("Belum punya KTP")
          .bodyLexend(size: 14)
      }
      .padding(.bottom)
      
      VStack(alignment: .leading, spacing: 8) {
        Text("Lokasi Kejadian")
          .bodyLexend(size: 12)
        
        VStack {
          TextView(
            text: $store.incident,
            textStyle: .lexendFont(style: .caption(size: 14)),
            textColor: .darkTextColor,
            backgroundColor: .gray050,
            placeholderText: "Lokasi kejadian kekerasan dalam konsultasi ini",
            placeholderColor: .gray200
          )
          .overlay(
            RoundedRectangle(cornerRadius: 6)
              .stroke(
                store.incidentErrorMessage.isEmpty ? Color.gray200 : Color.danger500,
                lineWidth: 2
              )
          )
        }
        .frame(maxWidth: .infinity, idealHeight: 88)
        .background(Color.gray050)
        .cornerRadius(6)
        
        if !store.incidentErrorMessage.isEmpty {
          Text(store.incidentErrorMessage)
            .foregroundColor(Color.danger500)
            .captionStyle(size: 12)
        }
      }
      .padding(.bottom)
      
    }
    .padding(.all, 12)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: Color.gray200, radius: 5)
    .focused($isFocused)
  }
  
  @ViewBuilder
  func descriptionTextView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      VStack(alignment: .leading) {
        TextView(
          text: $store.descriptions,
          textStyle: .lexendFont(style: .caption(size: 16)),
          textColor: .darkTextColor,
          backgroundColor: .gray050,
          placeholderText: "Contoh: Saya memiliki permasalahan hutang, tapi saya tidak tahu harus bagaimana",
          placeholderColor: .gray200
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              store.isShowErrorTextView()
              ? Color.danger500
              : store.descriptionErrorColor,
              lineWidth: 2
            )
        )
        .focused($isFocused)
      }
      .frame(maxWidth: .infinity, minHeight: 88)
      .background(Color.gray050)
      .cornerRadius(6)
      
      HStack {
        Text("Minimal 10 kata")
          .foregroundStyle(store.descriptionErrorColor)
          .captionLexend(size: 12)
        
        Spacer()
        
        Button {
          isFocused = false
          Task {
            await store.aiImproveAction()
          }
        } label: {
          HStack {
            Image(store.isAIActive ? "ic_write" : "ic_write_mono", bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 16, height: 16)
            
            Text(store.descriptionAIText)
              .foregroundStyle(store.isAIActive ? Color.gray600 : Color.gray300)
              .captionLexend(size: 10)
              .onReceive(store.timer) { time in
                if store.timeRemaining > 0 {
                  store.timeRemaining -= 1
                  let (minutes, second) = store.secondsToMinutesSeconds(store.timeRemaining)
                  store.descriptionAIText = "Tersedia dalam \(minutes):\(second)"
                } else {
                  store.descriptionAIText = "Edit Otomatis (AI)"
                }
              }
          }
          .padding(.vertical, 4)
          .padding(.horizontal, 8)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color.gray300, lineWidth: 1)
          }
        }
      }
    }
  }
  
  @ViewBuilder
  func reasonToContinueConsultation() -> some View {
    VStack(alignment: .leading) {
      Divider()
        .frame(maxWidth: .infinity)
        .background(Color.gray200)
        .padding(.bottom)
      
      Text("Alasan Konsultasi Lanjutan")
        .bodyLexend(size: 12)
      
      HStack {
        if let reason = store.selectedReason {
          Text(reason.title)
            .captionLexend(size: 16)
        } else {
          Text("Pilih alasan konsultasi lanjutan")
            .captionLexend(size: 16)
        }
        
        Spacer()
        
        Image("ic_chevron_down", bundle: .module)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.gray050)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8).stroke(Color.gray200)
      }
      .onTapGesture {
        store.isPresentReasonToContinue = true
      }
    }
  }
  
  @ViewBuilder
  func violenceOption() -> some View {
    VStack(alignment: .leading) {
      Text("Jenis Kekerasan")
        .titleLexend(size: 14)
      
      HStack {
        if let category = store.selectedViolence {
          LabelView(
            title: category.title,
            textColor: .primaryInfo600,
            radius: 12
          )
        } else {
          Text("Mohon pilih jenis kekerasan yang sesuai dengan masalah Anda")
            .foregroundStyle(Color.gray400)
            .captionLexend(size: 12)
        }
        
        Spacer()
        
        Button {
          withAnimation(.bouncy) {
            store.isPresentViolenceBottomSheet = true
            isFocused = false
          }
        } label: {
          HStack {
            Text("Pilih")
              .foregroundStyle(Color.buttonActiveColor)
              .titleLexend(size: 12)
            Image("arrow-down", bundle: .module)
          }
        }
      }
      
      if !store.violenceErrorMessage.isEmpty {
        Text(store.violenceErrorMessage)
          .foregroundStyle(Color.danger500)
          .captionLexend(size: 10)
          .padding(.top, 4)
      }
    }
  }
  
  @ViewBuilder
  func applicantOption() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Posisi Anda sebagai Pemohon Konsultasi")
        .bodyLexend(size: 12)
      
      ForEach(store.getApplicantOptions(), id: \.id) { option in
        RadioButtonView(
          label: option.title,
          isSelected: store.selectedApplicant == option,
          action: {
            store.selectedApplicant = option
            isFocused = false
          }
        )
      }
      
      if !store.applicantErrorMessage.isEmpty {
        Text(store.applicantErrorMessage)
          .foregroundStyle(Color.danger500)
          .captionLexend(size: 10)
      }
    }
  }
}

#Preview {
  OrderProcessKemenPPPAView(
    store: .init(
      advocate: .init(),
      selectedPriceCategories: .init(),
      sktmModel: nil,
      userSessionDataSource: MockUserSessionDataSource(),
      kemenPPPARepository: MockKemenPPPARepository(),
      repository: MockOrderProcessRepository(),
      treatmentRepository: MockTreatmentRepository(),
      orderServiceRepository: MockOrderServiceRepository(),
      probonoRepository: MockGetKTPRepository(),
      paymentNavigator: MockNavigator(),
      sktmNavigator: MockNavigator(),
      probonoNavigator: MockNavigator(),
      aiRepository: MockAIRepositoryLogic(),
      advocateNavigator: MockNavigator(),
      waitingRoomNavigator: MockNavigator()
    )
  )
}
