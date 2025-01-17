//
//  OrderProcessView.swift
//
//
//  Created by Ilham Prabawa on 22/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit
import Lottie

public struct OrderProcessView: View {
  
  @ObservedObject var store: OrderProcessStore
  @State private var reader: ScrollViewProxy?
  
  private init() {
    self.store = .init()
  }
  
  public init(store: OrderProcessStore) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack {
        ScrollViewReader { proxy in
          ScrollView {
            VStack(spacing: 12) {
              showLawyerInfo()
                .padding(.horizontal, 16)
              
              issueView {
                store.showChangeCategory()
              }
              .id(1)
              .padding(.horizontal, 16)
            }
            
            if store.orderServiceFilled {
              orderServiceOption()
                .padding(.horizontal, 16)
            }
            paymentDetail()
              .padding(.horizontal, 16)
            
              .padding(.top, 16)
              .padding(.bottom, 16)
          }.onAppear {
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
          onSelectPriceCategory: { price in
            store.setPriceCategory(price)
          },
          onSelectCategory: { viewModel in
            store.setSelected(viewModel)
          },
          onTap: {
            store.dismissChangeCategory()
          }
        )
        .frame(height: 350)
      }
      
      if store.isLoading {
        BlurView(style: .dark)
        
        LottieView {
          LottieAnimation.named("perqara-loading", bundle: .module)
        }
        .looping()
        .frame(width: 72, height: 72)
        .padding(.bottom, 50)
      }
      
    }
    .ignoresSafeArea(.keyboard)
  }
  
  @ViewBuilder
  func orderServiceOption() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Pilih Konsultasi")
        .foregroundColor(Color.darkTextColor)
        .titleLexend(size: 14)
      
      ForEach(store.getOrderServiceArrayModel()) { item in
        //MARK: some option maybe not use for now
        ProcessOrderOptionView(isDiscount: item.isDiscount,
                               isSKTM: item.isSKTM,
                               isHaveQuotaSKTM: item.isHaveQuotaSKTM,
                               isKTPActive: item.isKTPActive,
                               isSaving: item.isSaving,
                               quotaSKTM: item.quotaSKTM,
                               isDisable: item.isDisable,
                               isSelected: item.isSelected,
                               name: item.name,
                               type: item.type,
                               status: item.status,
                               duration: item.duration,
                               price: item.price,
                               original_price: item.original_price,
                               iconURL: URL(string: "\(item.icon_url)"),
                               descPrice: item.descPrice,
                               action: {
                                  store.selectedUpdate(type: item.type)
                                },
                               actionSKTM: {
                                  store.navigateToRequestProbono()
                                }
                                )
      }
      
    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
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
    }
  }
  
  
  @ViewBuilder
  func paymentDetail() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Rincian biaya")
        .titleLexend(size: 14)
      
      if store.detailCostFilled {
        FeeRowView(
          name: store.getName(),
          amount: store.getOriginalPrice(),
          showInfo: false,
          onTap: {
            GLogger(
              .info,
              layer: "Presentation",
              message: "did tap info"
            )
          }
        )
        
        FeeRowView(
          name: store.getDiscountName(),
          amount: store.getDiscountPrice(),
          showInfo: false,
          onTap: {
            GLogger(
              .info,
              layer: "Presentation",
              message: "did tap info"
            )
          }
        )
        
        Divider()
          .frame(height: 1)
        
        HStack {
          Text("Total Biaya")
            .titleLexend(size: 14)
          
          Spacer()
          
          Text(store.getPriceBottom())
            .titleLexend(size: 14)
        }
      }
      
      Text(store.getDetailInfoBottom())
        .foregroundColor(Color.darkGray400)
        .captionLexend(size: 12)
    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
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
    VStack {
      HStack(spacing: 12) {
        CircleAvatarImageView(
          imageURL,
          width: 48,
          height: 48
        )
        
        VStack(alignment: .leading, spacing: 4) {
          Text(name)
            .titleLexend(size: 14)
          
          Text(agency)
            .foregroundColor(.darkGray400)
            .bodyLexend(size: 14)
        }
        
        Spacer()
        
        Image("ic_order_service_right_arrow", bundle: .module)
        
      }
      .padding(.all, 12)
    }
    .frame(maxWidth: .infinity, maxHeight: 80)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }
  
  @ViewBuilder
  func issueView(onTap: @escaping () -> Void) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Tuliskan Deskripsi Masalah")
        .foregroundColor(.titleColor)
        .titleLexend(size: 14)
        .padding(.horizontal, 12)
        .padding(.top, 12)
      
      Text("Mohon ceritakan masalah yang akan Anda konsultasikan")
        .bodyLexend(size: 12)
        .padding(.horizontal, 12)
        .padding(.trailing, 50)
      
      ZStack(alignment: .topLeading) {
        VStack {
          TextView(
            text: $store.issueText,
            textStyle: .lexendFont(style: .caption(size: 12)),
            textColor: .darkTextColor,
            backgroundColor: .gray050
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
        .padding(.horizontal, 12)
        
        if store.issueText.isEmpty {
          Text("Contoh: Saya memiliki permasalahan hutang, tapi saya tidak tahu harus bagaimana")
            .foregroundColor(Color(.placeholderText))
            .captionLexend(size: 12)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .allowsHitTesting(false)
        }
        
      }
      
      
      Text(store.errorText)
        .foregroundColor(store.isTextValid ? Color.gray500 : Color.red)
        .bodyLexend(size: 12)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray200)
        .padding(.horizontal, 12)
      
      HStack {
        Text("Kategori Hukum")
          .titleLexend(size: 14)
          .padding(.horizontal, 12)
        
        Spacer()
        
        Button{
          onTap()
        } label: {
          Text("Ubah")
            .foregroundColor(Color.buttonActiveColor)
            .titleLexend(size: 14)
        }
      }
      .padding(.top, 10)
      .padding(.horizontal, 12)
      
      HStack(
        alignment: .center,
        spacing: 8
      ) {
        Text("Pidana") //store.getIssueName()
          .foregroundColor(Color.gray700)
          .titleLexend(size: 14)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(Color.clear)
          .cornerRadius(14)
      }
      
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.primaryInfo050)
      .cornerRadius(8)
      .padding(.horizontal, 12)
      
      HStack(
        alignment: .center,
        spacing: 8
      ) {
        Image("ic_warning", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)
        
        Text("Mohon pastikan kategori hukum yang Anda pilih sudah sesuai")
          .foregroundColor(.warning900)
          .captionLexend(size: 12)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(red: 0.99, green: 0.96, blue: 0.9))
      .cornerRadius(8)
      .padding(.horizontal, 12)
      .padding(.bottom, 12)
    }
    .frame(maxWidth: .infinity, minHeight: 180)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }
  
  @ViewBuilder
  func requestProbonoView(onTap: @escaping () -> Void) -> some View {
    VStack(spacing: 0) {
      HStack {
        Text("Ajukan layanan Pro bono?")
          .captionLexend(size: 12)
        
        Button {
          onTap()
        } label: {
          Text("Lihat detail")
            .foregroundColor(Color.buttonActiveColor)
            .bodyLexend(size: 12)
        }
      }
      
    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, minHeight: 32)
    .background(.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }
  
}

#Preview {
  OrderProcessView(store: .init())
}
