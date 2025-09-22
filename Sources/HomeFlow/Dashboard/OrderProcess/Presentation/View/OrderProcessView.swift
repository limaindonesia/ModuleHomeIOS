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
  @FocusState var isFocused: Bool
  
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
          ScrollView(showsIndicators: false) {
            
            VStack(spacing: 12) {
              showLawyerInfo()
                .padding(.horizontal, 16)
              
              //              issueView {
              //                store.showChangeCategory()
              //              }
              explanationView()
                .padding(.horizontal, 16)
              //              .id(1)
              //              .padding(.horizontal, 16)
            }
            .padding(.top, 16)
            
            orderServiceOptions()
              .padding(.horizontal, 16)
            
            paymentDetail()
              .padding(.horizontal, 16)
            
              .padding(.top, 16)
              .padding(.bottom, 16)
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
      .task {
        await store.fetchUserSession()
        await store.getLawyerReview()
        await store.getLawyerRating()
        await store.fetchProbonoStatus()
      }
      
      if store.isAIProcessing {
        Color.black.opacity(0.6)
          .zIndex(1)
        
        ShimmerText()
          .position(x: UIScreen.main.bounds.midX - 16, y: UIScreen.main.bounds.height / 2 - 200)
          .padding(.horizontal, 16)
          .zIndex(2)
      }
      
      BottomSheetNewView(isPresented: $store.isPresentDetailAdvocate) {
        AdvocateDetailInfoBottomSheetView(
          lawyer: store.advocate,
          reviews: store.reviews,
          totalReview: store.totalReview,
          showMore: {
            store.navigateToAdvocateDetailReview()
          }
        )
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
  func orderServiceOptions() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Pilih Konsultasi")
        .foregroundColor(Color.darkTextColor)
        .titleLexend(size: 14)
      
      ForEach(store.orderServiceViewModel, id: \.id) { item in
        ProcessOrderOptionView(
          isDiscount: item.isDiscount,
          isSKTM: false,
          isHaveQuotaSKTM: false,
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
          original_price: item.originalPrice,
          iconURL: URL(string: item.iconURL),
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
        toggleActive: $store.isProbonoActive,
        onTap: {
          store.isPresentDetailAdvocate = true
        }
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
        totalConsultation: store.getTotalConsultation(),
        onTap: {
          store.isPresentDetailAdvocate = true
        }
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
        
        if store.typeSelected != "PROBONO" {
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
        }
        
        Divider()
          .frame(height: 1)
        
        HStack {
          Text("Total Biaya")
            .titleLexend(size: 14)
          
          Spacer()
          
          Text(store.getTotalPrice())
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
        TextViewV2(
          text: $store.descriptions,
          textStyle: .lexendFont(style: .caption(size: 16)),
          textColor: .darkTextColor,
          backgroundColor: .gray050,
          placeholderText: "Contoh: Saya memiliki permasalahan hutang, tapi saya tidak tahu harus bagaimana",
          placeholderColor: .gray200,
          isError: .constant(false)
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
  OrderProcessView(store: .init())
}

import SwiftUI

struct ShimmerText: View {
  @State private var isAnimating = false
  private let fixedColumn = [
    GridItem(.flexible(minimum: 100, maximum: 300)),
    GridItem(.flexible(minimum: 100, maximum: 300))
  ]
  
  var body: some View {
    VStack {
      LazyVGrid(columns: fixedColumn, alignment: .leading) {
        
        ForEach(0..<5) { _ in
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray100)
            .overlay(
              shimmerOverlay
            )
            .mask(
              RoundedRectangle(cornerRadius: 8)
            )
        }
        
      }
    }
    .padding(.all, 8)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, maxHeight: 88)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .padding(.all, 8)
    .shadow(radius: 5)
    .onAppear {
      withAnimation(Animation.linear(duration: 2)
        .repeatForever(autoreverses: false)) {
          isAnimating = true
        }
    }
  }
  
  private var shimmerOverlay: some View {
    LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.6), .clear]),
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing)
    .rotationEffect(.degrees(30))
    .offset(x: isAnimating ? 200 : -200)
  }
}

#Preview{
  ShimmerText()
    .frame(height: 50)
}


public struct AIErrorBottomContentView: View {
  
  private let imageName: String
  private let title: String
  private let description: String
  private let buttonText: String
  private var onTap: () -> Void
  
  public init(
    imageName: String,
    title: String,
    description: String,
    buttonText: String,
    onTap: @escaping () -> Void
  ) {
    self.imageName = imageName
    self.title = title
    self.description = description
    self.buttonText = buttonText
    self.onTap = onTap
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .center, spacing: 8) {
        Image(imageName, bundle: .main)
          .resizable()
          .frame(width: 120, height: 120)
        
        Text(title)
          .titleLexend(size: 20)
        
      }.frame(maxWidth: .infinity, alignment: .center)
      
      Text(description)
        .captionLexend(size: 16)
        .padding(.top, 8)
      
      ButtonSecondary(
        title: buttonText,
        backgroundColor: .white,
        tintColor: .buttonActiveColor,
        width: .infinity,
        height: 40
      ) {
        onTap()
      }
      .padding(.top, 8)
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 30)
  }
  
}

#Preview {
  AIErrorBottomContentView(
    imageName: "ai_limit_error",
    title: "Mencapai Batas Pemakaian AI",
    description: "Batas penggunaan fitur perbaikan deskripsi dengan AI telah tercapai (10x). Anda bisa langsung menggunakan hasil terakhir atau ubah manual jika diperlukan",
    buttonText: "Ubah deskripsi masalah",
    onTap: {}
  )
}


public struct AIUndismissableBottomContentView: View {
  
  private let imageName: String
  private let title: String
  private let description: String
  private var onTapAdvocateLists: () -> Void
  private var onTapBack: () -> Void
  
  public init(
    imageName: String,
    title: String,
    description: String,
    onTapAdvocateLists: @escaping () -> Void,
    onTapBack: @escaping () -> Void
  ) {
    self.imageName = imageName
    self.title = title
    self.description = description
    self.onTapAdvocateLists = onTapAdvocateLists
    self.onTapBack = onTapBack
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .center, spacing: 8) {
        Image(imageName, bundle: .main)
          .resizable()
          .frame(width: 120, height: 120)
        
        Text(title)
          .titleLexend(size: 20)
        
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.bottom, 8)
      
      Text(description)
        .captionLexend(size: 16)
        .padding(.top, 8)
      
      ButtonPrimary(
        title: "Lihat Daftar Advokat",
        color: .buttonActiveColor,
        width: .infinity,
        height: 40
      ) {
        onTapAdvocateLists()
      }
      
      ButtonSecondary(
        title: "Kembali ke Beranda",
        backgroundColor: .white,
        tintColor: .buttonActiveColor,
        width: .infinity,
        height: 40
      ) {
        onTapBack()
      }
      .padding(.top, 8)
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 30)
  }
}

#Preview {
  AIUndismissableBottomContentView(
    imageName: "ai_limit_error",
    title: "Akses Sementara Dibatasi",
    description: "Kami mendeteksi pola penggunaan yang tidak biasa. Anda tidak menggunakan fitur AI ini untuk sementara waktu.",
    onTapAdvocateLists: {},
    onTapBack: {}
  )
}
