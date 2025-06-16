//
//  OrderProcessKemenPPPA.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 16/06/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct OrderProcessKemenPPPA: View {
  
  @ObservedObject var store: OrderProcessStore
  @State private var reader: ScrollViewProxy?
  @FocusState var isFocused: Bool
  
  var body: some View {
    ZStack {
      VStack {
        ScrollViewReader { proxy in
          
          ScrollView(showsIndicators: false) {
            
            VStack(spacing: 12) {
              showLawyerInfo()
                .padding(.horizontal, 16)
              
              explanationView()
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
            
          }
          .onAppear {
            self.reader = proxy
          }
        }
        
        Spacer()
        
        PaymentBottomView(
          title: "Biaya",
          price: store.getPriceBottom(),
          totalAdjustment: "",
          buttonText: "Ke Pembayaran",
          isVoucherApplied: false,
          isButtonActive: store.buttonActive,
          onTap: {
            if store.buttonActive {
              if store.isScrollToTop {
                store.setErrorText()
                withAnimation(.smooth) {
                  self.reader?.scrollTo(1, anchor: .topTrailing)
                }
              } else {
                store.processNavigation()
              }
            }
          }
        )
        .padding(.horizontal, 16)
      }
      .onAppear {
        Task {
          await store.fetchUserSession()
          await store.fetchProbonoStatus()
        }
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
      
    }
    .ignoresSafeArea(.keyboard)
  }
  
  @ViewBuilder
  func showLawyerInfo() -> some View {
    if store.isProbono() {
      LawyerInfoProbonoView(
        imageURL: store.lawyerInfoViewModel.imageURL,
        name: store.lawyerInfoViewModel.name,
        agency: store.lawyerInfoViewModel.agency,
        price: store.getPriceProbonoOnly(),
        originalPrice: store.lawyerInfoViewModel.originalPrice,
        isDiscount: store.lawyerInfoViewModel.isDiscount,
        isProbono: $store.isProbonoActive,
        timeStr: store.timeConsultation,
        toggleActive: $store.isProbonoActive
      )
    } else {
      LawyerInfoView(
        imageURL: store.lawyerInfoViewModel.imageURL,
        name: store.lawyerInfoViewModel.name,
        agency: store.lawyerInfoViewModel.agency,
        price: store.lawyerInfoViewModel.price,
        originalPrice: store.lawyerInfoViewModel.originalPrice,
        isDiscount: store.lawyerInfoViewModel.isDiscount,
        isProbono: store.lawyerInfoViewModel.isProbono,
        timeStr: store.timeConsultation,
        experience: store.getExperience(),
        rating: store.getRating(),
        totalConsultation: store.getTotalConsultation()
      )
    }
  }
  
  @ViewBuilder
  func explanationView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Tuliskan Deskripsi Masalah")
        .titleLexend(size: 16)
        .padding(.bottom, 8)
      
      Text("Mohon ceritakan masalah yang akan Anda konsultasikan")
        .captionLexend(size: 12)
      
      descriptionTextView()
        .coordinateSpace(name: "DESCRIPTION")
      
    }
    .padding(.all, 12)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: Color.gray200, radius: 5)
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
            .stroke(store.isShowErrorTextView() ? Color.danger500 : store.descriptionErrorColor , lineWidth: 2)
        )
        .focused($isFocused)
      }
      .frame(maxWidth: .infinity, minHeight: 88)
      .background(Color.gray050)
      .cornerRadius(6)
      
      HStack {
        Text(store.descriptionErrorMessage)
          .foregroundStyle(store.isShowErrorTextView() ? Color.danger500 : store.descriptionErrorColor)
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
                  let (m,s) = store.secondsToMinutesSeconds(store.timeRemaining)
                  store.descriptionAIText = "Tersedia dalam \(m):\(s)"
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
}

#Preview {
  OrderProcessKemenPPPA(store: .init())
}
