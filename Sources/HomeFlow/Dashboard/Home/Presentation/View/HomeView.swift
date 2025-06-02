//
//  HomeView.swift
//
//
//  Created by Ilham Prabawa on 09/10/24.
//

import SwiftUI
import GnDKit
import AprodhitKit
import Lottie
import Combine
import Kingfisher
import PromotionModule
import AprodhitAuthModule

public struct HomeView: View {
  @ObservedObject var store: HomeStore
  @State var offSet: CGFloat = 0
  @State var isRefreshing: Bool = false
  @State var refresh: Refresh = Refresh(
    started: false,
    released: false
  )
  @State private var photosIndex = 0
  
  public init(store: HomeStore) {
    self.store = store
  }
  
  public var body: some View {
    
    ZStack {
      
      loadContent(width: 0)
      
      BottomSheetView(isPresented: $store.isPresentSuccessDeleteAccount) {
        DeleteAccountBottomSheetContentView(store: store)
      }
      
      BottomSheetView(isPresented: $store.isPresentLoginBottomSheet) {
        LoginBottomSheetContentView(store: store)
      }
      
      BottomSheetView(isPresented: $store.isConsultationNowSheetPresented) {
        consultationAIBottomSheetContent {
          store.hideConsultationNowBottomSheet()
          store.navigateToAdvocateListWithSkill()
        } onTapDecisionTree: {
          store.hideConsultationNowBottomSheet()
          store.navigateToDecisionTree()
        }
      } onDismissed: {
        store.hideConsultationNowBottomSheet()
      }
      
      BottomSheetView(isPresented: $store.isCategorySheetPresented) {
        categoryBottomSheetContent(
          models: store.selectedSkill?.types ?? [],
          selectedModel: store.selectedSkill ?? .init()
        ) {
          store.navigateToAdvocateListWithSkill()
        }
      } onDismissed: {
        store.hideCategoryBottomSheet()
      }
      
      BottomSheetView(
        isPresented: $store.isPresentReasonBottomSheet,
        dismissable: true
      ) {
        CancelationReasonContentView(
          store: CancelationReasonStore(
            arrayReasons: store.reasons
          ),
          imageURL: store.getImageURL(),
          lawyerName: store.getLawyersName(),
          onSendReason: { (entity, reason) in
            store.selectedReason = entity
            store.reason = reason
            Task {
              await store.requestCancelReason()
            }
            
            GLogger(
              .info,
              layer: "Presentation",
              message: "send reason \(entity.id) : \( entity.title) : \(reason)"
            )
          }
        )
        .padding(.bottom, 80)
        
      } onDismissed: {
        Task { await store.dismissReason() }
        store.hideReasonBottomSheet()
      }
      
      promotionBanner(
        $store.isPresentPromotionBanner,
        imageURL: store.promotionBannerViewModel.popupImageURL
      )
      
      //      if store.isLoading {
      //        BlurView(style: .dark)
      //
      //        LottieView {
      //          LottieAnimation.named("perqara-loading", bundle: .module)
      //        }
      //        .looping()
      //        .frame(width: 72, height: 72)
      //        .padding(.bottom, 50)
      //      }
      
      if store.showLoginSnackbar {
        GeometryReader { proxy in
          let frame = proxy.frame(in: .local)
          SnackBarView(
            showSnackBar: $store.showLoginSnackbar,
            message: NSLocalizedString(Constant.Text.LOGGED_IN_SUCCESSFUL, comment: "")
          )
          .position(x: frame.midX, y: frame.minY + 100)
        }
      }
      
    }
    .ignoresSafeArea(edges: .all)
    .onAppear {
      Task {
        await store.fetchUserSession()
        await store.fetchOngoingUserCases()
        await store.requestMe()
        await store.checkBottomSheet()
        await store.fetchPromotionLists()
      }
    }
    
  }
  
  @ViewBuilder
  func loadContent(width: CGFloat) -> some View {
    if store.showShimmer {
      LazyVStack {
        ForEach(0..<5) { _ in
          CardShimmer()
        }
      }
      .padding(.top, 100)
    } else {
      homeContentView()
    }
  }
  
  @ViewBuilder
  func activeConsultationView() -> some View {
    if store.ongoingConsultation {
      headerWithOngoingView(
        store.arrayOfuserCases,
        name: store.name
      )
      
      ongoingView(store.userCases)
        .padding(.top, 100)
      
    } else {
      headerView(
        store.isLoggedIn,
        name: store.name,
        onTapLogIn: {
          store.navigateToLogin()
        }
      )
      
      probonoServiceNewView {
        store.navigateToDecisionTree()
      } onTapConsultation: {
        store.navigateToAdvocateList()
      } onTapProbonoService: {
        store.navigateToProbonoService()
      }.padding(.top, 355)
      
      activeAdvocates(store.onlinedAdvocates)
        .padding(.top, 32)
    }
  }
  
  @ViewBuilder
  func homeContentView() -> some View {
    VStack {
      navigationBarView()
        .zIndex(1)
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          
          /*if store.activeViewModels.isEmpty {
           activeConsultationView()
           } else {
           headerWithDocumentActiveView(name: store.name)
           
           probonoServiceView {
           store.navigateToDecisionTree()
           } onTapConsultation: {
           store.navigateToAdvocateList()
           } onTapProbonoService: {
           store.navigateToProbonoService()
           }.padding(.top, 250)
           
           activeAdvocates(store.onlinedAdvocates)
           }*/
          
          activeConsultationView()
          
          topAdvocatesNew(
            store.getFourTopAdvocates(),
            month: store.topAdvocateMonth,
            onTap: { store.navigateToDetailTopAdvocate() }
          )
          .frame(height: 230)
          .padding(.top, 16)
          
          gridCategory(
            store.showCategories,
            onTap: { skill in
              store.selectedSkill = skill
              store.showCategoryBottomSheet()
            }
          )
          
          lawArticles(
            categories: store.categories,
            articles: store.articles,
            selectedID: store.articleSelectedID
          )
          .padding(.bottom, 80)
          
        }
        .frame(maxWidth: .infinity)
      }
      .background(Color.gray050)
      .padding(.top, -10)
      .refreshable {
        Task {
          await store.onRefresh()
          isRefreshing = false
          refresh.started = false
          refresh.released = false
        }
      }
    }
    
  }
  
  @ViewBuilder
  func navigationBarView() -> some View {
    Color.buttonActiveColor
      .frame(maxWidth: .infinity, maxHeight: 53)
      .background(Color.buttonActiveColor)
  }
  
  @ViewBuilder
  func headerView(
    _ isLoggedIn: Bool,
    name: String,
    onTapLogIn: @escaping () -> Void
  ) -> some View {
    
    ZStack {
      
      GeometryReader { geometry in
        
        let frame = geometry.frame(in: .global)
        
        VStack {
          HStack(alignment: .center) {
            Image("perqara_logo", bundle: .module)
            VStack(alignment: .leading) {
              Text("Selamat datang,")
                .foregroundColor(.white)
                .captionStyle(size: 10)
              
              Text(isLoggedIn ? name : "Sobat Perqara!")
                .foregroundColor(.white)
                .titleStyle(size: 12)
            }
            
            Spacer()
            
            if !isLoggedIn {
              ButtonSecondary(
                title: "Masuk Akun",
                backgroundColor: Color.white,
                tintColor: Color.buttonActiveColor,
                width: 108,
                height: 32
              ) {
                onTapLogIn()
              }
            }
          }
          .padding(.top, 16)
          .padding(.horizontal, 16)
          .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color.buttonActiveColor)
        
        VStack {
          SearchView(onTap: {
            store.navigateToSearch(with: "")
          })
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color(red: 0.04, green: 0.31, blue: 0.64), location: 0.00),
              Gradient.Stop(color: Color(red: 0.32, green: 0.51, blue: 0.74).opacity(0.71), location: 0.45),
              Gradient.Stop(color: .white.opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.48, y: 0.55),
            endPoint: UnitPoint(x: 0.48, y: 1)
          )
        )
        .position(x: frame.midX, y: 100)
        .zIndex(1)
        
        ZStack {
          ForEach(0 ..< store.systemImages.count, id:\.self) { indexDot in
            Image(
              store.getImageDot(
                indexSelectedImage: photosIndex,
                indexSelectedDot: indexDot
              ),
              bundle: .module
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 10,height: 10)
            .position(x: CGFloat(store.systemImagesX[indexDot]), y: 355)
          }
          .zIndex(1)
          
          InfinitePageView(
            selection: $photosIndex,
            before: { store.correctedIndex(for: $0 - 1) },
            after: { store.correctedIndex(for: $0 + 1) },
            view: { index in
              Image(store.systemImages[index], bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .onTapGesture {
                  store.navigationBannerHome(index: index)
                }
            }
          )
          .position(x: frame.midX, y: 240)
          .frame(height: 300)
          .zIndex(0)
        }
        .zIndex(0)
      }
      
    }
  }
  
  @ViewBuilder
  func headerWithDocumentActiveView(name: String) -> some View {
    ZStack {
      
      GeometryReader { geometry in
        
        let frame = geometry.frame(in: .global)
        
        VStack(alignment: .leading) {
          
          HStack(alignment: .center) {
            
            Image("perqara_logo", bundle: .module)
            
            VStack(alignment: .leading) {
              Text("Selamat datang,")
                .foregroundColor(.white)
                .captionStyle(size: 10)
              
              Text(name)
                .foregroundColor(.white)
                .titleStyle(size: 12)
            }
            
            Spacer()
          }
          .padding(.top, 16)
          .padding(.horizontal, 16)
          .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color.buttonActiveColor)
        
        VStack {
          SearchView(onTap: {
            store.navigateToSearch(with: "")
          })
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color(red: 0.04, green: 0.31, blue: 0.64), location: 0.00),
              Gradient.Stop(color: Color(red: 0.32, green: 0.51, blue: 0.74).opacity(0.71), location: 0.45),
              Gradient.Stop(color: .white.opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.48, y: 0.55),
            endPoint: UnitPoint(x: 0.48, y: 1)
          )
        )
        .position(x: frame.midX, y: 100)
        .zIndex(1)
        
        LinearGradient(
          colors: [Color.white, Color.gradientBlue],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 240)
        .position(x: frame.midX, y: 240)
        .zIndex(0)
        
        LazyVStack {
          ForEach(store.activeViewModels, id: \.id) { model in
            activeDocument(model)
          }
        }
        .position(x: frame.midX, y: 210)
        .zIndex(0)
      }
      
    }
    
  }
  
  @ViewBuilder
  func headerWithOngoingView(
    _ items: [UserCases],
    name: String
  ) -> some View {
    ZStack {
      
      GeometryReader { geometry in
        
        let frame = geometry.frame(in: .global)
        
        VStack {
          HStack(alignment: .center) {
            Image("perqara_logo", bundle: .module)
            VStack(alignment: .leading) {
              Text("Selamat datang,")
                .foregroundColor(.white)
                .captionStyle(size: 10)
              
              Text(name)
                .foregroundColor(.white)
                .titleStyle(size: 12)
            }
            
            Spacer()
          }
          .padding(.top, 16)
          .padding(.horizontal, 16)
          .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color.buttonActiveColor)
        
        VStack {
          SearchView(
            onTap: {
              store.navigateToSearch(with: "")
            }
          )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .background(
          LinearGradient(
            colors: [
              Color.buttonActiveColor,
              Color.primary200,
              Color.white
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .position(x: frame.midX, y: 100)
        .zIndex(1)
        
        LinearGradient(
          colors: [Color.white, Color.gradientBlue],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 150)
        .position(x: frame.midX, y: 250)
        .zIndex(0)
        
      }
      
    }
  }
  
  @ViewBuilder
  func activeDocument(_ model: DocumentBaseViewModel) -> some View {
    if let waitingForPaymentModel = model as? DocumentActiveViewModel {
      HomeDocumentActiveRowView(viewModel: waitingForPaymentModel)
    }
    
    if let processModel = model as? DocumentOnProcessViewModel {
      DocumentOnProcessRowView(viewModel: processModel)
    }
  }
  
  @ViewBuilder
  func ongoingView(_ item: UserCases) -> some View {
    
    if item.status == Constant.Home.Text.ORDER_PENDING {
      
      WaitingForPaymentView(
        imageURL: item.lawyer?.getImageName(),
        statusText: item.getStatus() ?? "",
        timeRemaining: item.getTimeRemaining(),
        date: item.getDateString(),
        lawyersName: item.lawyer?.getName() ?? "",
        issueType: item.skill?.name ?? "",
        price: item.getPrice(),
        onTap: {
          store.navigateToPayment()
        },
        onTimerTimesUp: {
          Task {
            //await store.fetchOngoingUserCases()
          }
        }
      )
      
    } else if item.status == Constant.Home.Text.WAITING_FOR_PAYMENT {
      
      WaitingForPaymentView(
        imageURL: item.lawyer?.getImageName(),
        statusText: item.getStatus() ?? "",
        timeRemaining: item.getPaymentTimeRemainig(),
        date: item.getDateString(),
        lawyersName: item.lawyer?.getName() ?? "",
        issueType: item.skill?.name ?? "",
        price: item.getPrice(),
        onTap: {
          store.navigateToPaymentCheck()
        },
        onTimerTimesUp: {
          Task {
            await store.fetchOngoingUserCases()
          }
        }
      )
      
    } else if item.status == Constant.Home.Text.WAITING_FOR_APPROVAL {
      
      WaitingForConfirmationView(
        imageURL: item.lawyer?.getImageName(),
        statusText: item.getStatus() ?? "",
        date: item.getDateString(),
        lawyersName: item.lawyer?.getName() ?? "",
        issueType: item.skill?.name ?? "",
        onTap: {
          store.navigateToWaitingRoom(isProbono: item.service_type == "PROBONO")
        }
      )
      
    } else if item.status == Constant.Home.Text.ON_PROCESS {
      
      OngoingConsultationView(
        imageURL: item.lawyer?.getImageName(),
        statusText: item.getStatus() ?? "",
        statusColor: Color(hex: item.getStatusColor()),
        statusTextColor: Color(hex: item.getStatusTextColor()),
        date: item.getDateString(),
        lawyersName: item.lawyer?.getName() ?? "",
        issueType: item.skill?.name ?? "",
        buttonText: Constant.Home.Text.BACK_TO_CONSULTATION,
        onTap: {
          store.navigateToConsultationChat()
        }
      )
      
    } else {
      
      OngoingConsultationView(
        imageURL: item.lawyer?.getImageName(),
        statusText: item.getStatus() ?? "",
        statusColor: Color(hex: item.getStatusColor()),
        statusTextColor: Color(hex: item.getStatusTextColor()),
        date: item.getDateString(),
        lawyersName: item.lawyer?.getName() ?? "",
        issueType: item.skill?.name ?? "",
        buttonText: item.getButtonText(),
        onTap: {
          store.navigateToWaitingRoom(isProbono: item.service_type == "PROBONO")
        }
      )
      
    }
    
  }
  
  @ViewBuilder
  func bannerUnauthorized() -> some View {
    GeometryReader { geometry in
      let proxy = geometry.frame(in: .global)
      VStack(alignment: .leading) {
        Text(
          NSLocalizedString(
            Constant.Home.Text.NOT_LOGGEDIN_TITLE,
            comment: ""
          )
        )
        .captionStyle(size: 14)
        Text(
          NSLocalizedString(
            Constant.Home.Text.NOT_LOGGEDIN_TITLE2,
            comment: ""
          )
        )
        .captionStyle(size: 14)
      }
      .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(Color.bgSendWarning)
      .padding(.bottom, 30)
      .position(x: screen.midX, y: proxy.minY + 90)
    }
  }
  
  @ViewBuilder
  func indicatorView() -> some View {
    if isRefreshing {
      ProgressView()
        .padding(.bottom, 16)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func probonoServiceView(
    onTapDecisionTree: @escaping () -> Void,
    onTapConsultation: @escaping () -> Void,
    onTapProbonoService: @escaping () -> Void
  ) -> some View {
    VStack(spacing: 8) {
      
      HStack(alignment: .center, spacing: 8) {
        
        Image("ic_moto_2", bundle: .module)
          .resizable()
          .frame(width: 38, height: 38)
          .aspectRatio(contentMode: .fill)
          .padding(.trailing, 12)
          .padding(.top, 5)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Konsultasi Hukum Online")
            .titleLexend(size: 16)
          Text("Rasakan BEBASnya konsultasi hukum via chat, voice call atau video call.")
            .lineLimit(2)
            .captionLexend(size: 12)
        }
      }
      .padding(.horizontal, 10)
      .padding(.top, 12)
      
      ZStack {
        Image("ic_disc_60_home", bundle: .module)
          .resizable()
          .frame(width: 55, height: 17)
          .aspectRatio(contentMode: .fit)
          .padding(.top, -28)
          .position(x: screen.width - 80, y: 30)
          .zIndex(1)
        
        Button {
          store.showConsultationNowBottomSheet()
        } label: {
          HStack {
            Text("Konsultasi Sekarang")
              .foregroundColor(Color.white)
              .titleLexend(size: 12)
            
            Image(systemName: "arrow.forward")
              .resizable()
              .frame(width: 10.67, height: 10.67)
              .foregroundColor(.white)
          }
          .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(Color.buttonActiveColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              Color.white,
              lineWidth: 1
            )
        )
        .padding(.horizontal, 10)
        .padding(.top, 0)
      }
      .frame(maxWidth: .infinity, maxHeight: 60)
      
      HStack {
        Image("ic_probono_2", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)
        
        Text("Konsultasi Gratis dengan Pro bono")
          .titleLexend(size: 10)
        
        Spacer()
        
        Text(store.actionTitle())
      }
      .padding(.horizontal, 12)
      .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
      .background(
        LinearGradient(
          colors: [
            Color.gradientBlue,
            Color.gradientBlue2,
            Color.gradientBlue2
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(
            Color.primaryInfo200,
            lineWidth: 1
          )
      )
      .padding(.horizontal, 10)
      .padding(.bottom, 8)
      .onTapGesture {
        onTapProbonoService()
      }
    }
    .frame(maxWidth: .infinity, minHeight: 220)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .gray200, radius: 10, x: 0, y: 15)
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func probonoServiceNewView(
    onTapDecisionTree: @escaping () -> Void,
    onTapConsultation: @escaping () -> Void,
    onTapProbonoService: @escaping () -> Void
  ) -> some View {
    VStack(spacing: 8) {
      
      Text("Layanan Hukum Perqara")
        .titleLexend(size: 16)
        .padding(.top, 16)
      
      HStack(spacing: 8) {
        
        Button {
          store.showConsultationNowBottomSheet()
        } label: {
          HStack {
            Image("ic_online_consultation", bundle: .module)
            
            Text("Konsultasi Hukum Online")
              .titleLexend(size: 12)
              .multilineTextAlignment(.leading)
          }
          .padding(.all, 8)
          .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        
        Button {
          store.navigateToNotary()
        } label: {
          HStack {
            Image("ic_notary", bundle: .module)
            
            Text("Pendirian Badan Usaha")
              .titleLexend(size: 12)
              .multilineTextAlignment(.leading)
          }
          .padding(.all, 8)
          .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        
      }
      .padding(.horizontal, 16)
      
      if store.hasPromotion() {
        HStack {
          Image("ic_promo", bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
          
          Text("Promo yang tersedia")
            .captionLexend(size: 12)
          
          Spacer()
          
          Image(systemName: "arrow.right")
            .foregroundStyle(Color.primaryInfo700)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, idealHeight: 40, alignment: .center)
        .background(
          LinearGradient(
            colors: [
              Color.gradientBlue,
              Color.gradientBlue2,
              Color.gradientBlue2
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              Color.primaryInfo200,
              lineWidth: 1
            )
        )
        .padding(.horizontal, 16)
        .onTapGesture {
          store.navigateToListPromotion()
        }
      }
      
      HStack {
        Image("ic_libra", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 12, height: 8)
        
        HStack(spacing: 1) {
          Text("Dapatkan konsultasi gratis, pelajari")
            .foregroundStyle(Color.white)
            .captionLexend(size: 12)
          Text(createDottedText("di sini", underline: true))
            .foregroundStyle(Color.white)
            .captionLexend(size: 12)
            .onTapGesture {
              onTapProbonoService()
            }
        }
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, idealHeight: 26, alignment: .leading)
      .background(Color.primaryInfo700)
      .clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 12))
      
      
    }
    .background(
      LinearGradient(
        colors: [Color.white, Color.primary200],
        startPoint: .top,
        endPoint: .bottom
      )
    )
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .gray200, radius: 10, x: 0, y: 15)
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func activeAdvocates(_ items: [Advocate]) -> some View {
    if store.showOnlineAdvocates {
      VStack(alignment: .leading, spacing: 8) {
        
        VStack(alignment: .leading, spacing: 4) {
          Text(
            NSLocalizedString(
              Constant.Home.Text.ONLINE_ADVOCATE,
              comment: ""
            )
          )
          .foregroundColor(Color.black)
          .titleLexend(size: 16)
          
          Text(
            NSLocalizedString(
              Constant.Home.Text.SUBTITLE_ONLINE_ADVOCATE,
              comment: ""
            )
          )
          .foregroundColor(Color.gray500)
          .bodyLexend(size: 11)
        }
        .padding(.leading, 16)
        
        Spacer()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(items, id: \.id) { advocate in
              AdvocateOnlineRow(
                name: advocate.getName(),
                imageName: advocate.getImageName(),
                location: advocate.getLocation(),
                experience: advocate.getExperience(),
                rating: advocate.getRating(),
                totalConsultation: advocate.total_consultations ?? 0,
                price: advocate.createPrice(),
                originalPrice: advocate.getOriginalPrice(),
                isDiscount: advocate.isDiscount,
                //MARK: need to fix
                isProbono: false,
                voucherCampaign: advocate.getVoucherCampaign(),
                onTap: {
                  store.navigateToDetailAdvocate(advocate)
                },
                onTapConsultation: {}
              )
            }
          }
          .padding(.horizontal, 16)
        }
        
        Button {
          store.navigateToSeeAllAdvocate()
        } label: {
          HStack {
            Text("Lihat Semua")
              .foregroundStyle(Color.primaryInfo700)
              .titleLexend(size: 14)
            
            Image("arrow-right", bundle: .module)
          }
          .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
          .padding(.top, 16)
        }
        
      }
    }
  }
  
  @ViewBuilder
  func seeAllAdvocate() -> some View {
    Button {
      store.navigateToSeeAllAdvocate()
    } label: {
      Text("Semua Advokat Online")
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, minHeight: 48)
        .background(Color.purple)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }.id("SEE_ALL_BUTTON")
  }
  
  @ViewBuilder
  func gridCategory(
    _ show: Bool,
    onTap: @escaping (AdvocateSkills) -> Void
  ) -> some View {
    if show {
      VStack {
        
        HStack {
          Text("Pilih dari Kategori")
            .bodyStyle(size: 20)
          
          Spacer()
          
          SeeAllView(text: "Selengkapnya") {
            store.navigateToDetailCategory()
          }
          
        }
        .frame(minHeight: 50)
        .padding(.horizontal, 16)
        
        LazyVGrid(
          columns: [
            .init(.adaptive(minimum: 160), spacing: 0),
            .init(.adaptive(minimum: 160), spacing: 0)
          ],
          content: {
            ForEach(store.skills, id: \.id) { skill in
              SkillRowView(
                iconName: skill.getIconName(by: skill.id ?? 0),
                skillName: skill.skillName,
                subSkillName: skill.getType(),
                additionalCount: skill.getAdditionalCount()
              )
              .onTapGesture {
                onTap(skill)
              }
            }
          }
        )
        .id("CATEGORY_GRID")
        .padding(.horizontal, 10)
      }
    }
    
  }
  
  @ViewBuilder
  func topView() -> some View {
    VStack {
      topAdvocates(store.topAdvocates)
        .padding(.bottom, 16)
      
      DashedLine()
        .padding(.horizontal, 16)
      
      topAgencies(store.topAgencies)
        .padding(.top, 16)
    }
  }
  
  @ViewBuilder
  func topAdvocatesNew(
    _ items: [TopAdvocateViewModel],
    month: String,
    onTap: @escaping () -> Void
  ) -> some View {
    
    TopAdvocateContentView(
      items: items,
      month: month,
      onTapAction: onTap
    )
    
  }
  
  @ViewBuilder
  func topAdvocates(_ items: [TopAdvocateViewModel]) -> some View {
    
    VStack(alignment: .leading) {
      
      Text("Top Advokat Bulan Ini")
        .bodyStyle(size: 20)
        .padding(.leading, 16)
        .padding(.bottom, 8)
      
      ForEach(items, id: \.id) { item in
        VStack(spacing: 0) {
          TopAdvocateRowView(
            imageName: item.getImageURL(),
            title: item.name,
            description: item.agency,
            ranking: item.position
          )
          .frame(maxWidth: .infinity, minHeight: 76)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.horizontal, 16)
        }
      }
      
    }
    
  }
  
  @ViewBuilder
  func topAgencies(_ items: [TopAgencyViewModel]) -> some View {
    
    VStack(alignment: .leading) {
      
      Text("Top Instansi Bulan Ini")
        .bodyStyle(size: 20)
        .padding(.leading, 16)
        .padding(.bottom, 8)
      
      ForEach(items, id: \.position) { item in
        VStack(spacing: 0) {
          TopAgencyRowView(
            imageName: item.getIconName(by: item.position),
            title: item.getName(),
            ranking: item.position
          )
          .frame(maxWidth: .infinity, minHeight: 76)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.horizontal, 16)
        }
      }
      
    }
  }
  
  @ViewBuilder
  func lawArticles(
    categories: [CategoryArticleViewModel],
    articles: [ArticleViewModel],
    selectedID: Int
  ) -> some View {
    
    VStack(spacing: 12) {
      
      ScrollView(.horizontal, showsIndicators: false) {
        
        LazyHStack {
          
          ForEach(categories) { item in
            VStack {
              Text(item.name)
                .foregroundColor(item.selected ? .white : .black)
                .bodyStyle(size: 12)
                .padding(.horizontal, 16)
            }
            .frame(height: 30)
            .background(item.selected ? Color.buttonActiveColor : .white)
            .cornerRadius(16)
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray100, lineWidth: 1)
            )
            .onTapGesture {
              Task {
                await store.selectCategory(item.id, name: item.name)
              }
            }
          }
          
        }
        .frame(height: 30)
        .padding(.horizontal, 16)
      }
      
      
      ScrollView(.horizontal, showsIndicators: false) {
        
        LazyHStack {
          
          ForEach(articles) { item in
            
            VStack(spacing: 2) {
              VStack {
                KFImage(item.getArticleImage())
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 150, height: 80)
              }
              .background(Color.white)
              .cornerRadius(8)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.gray100, lineWidth: 1)
              )
              
              Text(item.title)
                .lineLimit(2)
                .captionStyle(size: 12)
                .frame(width: 150, height: 50)
            }
            .onTapGesture {
              store.navigateToDetailArticle(id: item.id)
            }
            
          }
        }
        .frame(height: 180)
        .padding(.horizontal, 16)
      }
      
    }
    .padding(.bottom, 80)
    
  }
  
  @ViewBuilder
  func consultationNowBottomSheetContent(
    onTap: @escaping () -> Void,
    onTapConsultation: @escaping () -> Void,
    onTapDecisionTree: @escaping () -> Void,
    onTapProbono: @escaping() -> Void
  ) -> some View {
    
    VStack(alignment: .leading, spacing: 16) {
      
      HStack {
        Text(
          NSLocalizedString(
            Constant.Home.Text.CONSULTATION_TITLE,
            comment: ""
          )
        )
        .titleLexend(size: 20)
        
        Spacer()
        
        Image("ic_disc_60", bundle: .module)
          .resizable()
          .frame(width: 73, height: 23)
          .aspectRatio(contentMode: .fit)
          .zIndex(0)
      }
      .frame(minHeight: 30)
      
      VStack(alignment: .leading, spacing: 16) {
        
        HStack(alignment: .center, spacing: 8) {
          
          Image("ic_people", bundle: .module)
            .resizable()
            .frame(width: 40, height: 40)
            .aspectRatio(contentMode: .fill)
            .padding(.horizontal, 8)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(
              NSLocalizedString(
                Constant.Home.Text.SHOW_ALL_ADVOCATE,
                comment: ""
              )
            )
            .titleLexend(size: 14)
            .frame(width: 150, height: 20, alignment: .leading)
            .padding(.top, 8)
            
            Text(
              NSLocalizedString(
                Constant.Home.Text.SUB_SHOW_ALL_ADVOCATE,
                comment: ""
              )
            )
            .foregroundColor(Color.init(hex: 0x4D5B6A))
            .captionLexend(size: 12)
            .padding(.bottom, 8)
          }
          
          Spacer()
          
          Image("ic_right_arrow", bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
            .aspectRatio(contentMode: .fill)
            .padding(.horizontal, 8)
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: 125,
          alignment: .leading
        )
        .padding(.horizontal, 12)
        .background(Color.init(hex: 0xF3FBFF))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              Color.init(hex: 0xEEF2F7),
              lineWidth: 1
            )
        )
        .onTapGesture {
          onTapConsultation()
        }
        
        HStack(alignment: .center, spacing: 8) {
          
          Image("ic_book", bundle: .module)
            .resizable()
            .frame(width: 40, height: 40)
            .aspectRatio(contentMode: .fill)
            .padding(.horizontal, 8)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(
              NSLocalizedString(
                Constant.Home.Text.GUIDE_ADVOCATE,
                comment: ""
              )
            )
            .titleLexend(size: 14)
            .frame(
              width: 200,
              height: 20,
              alignment: .leading
            )
            .padding(.top, 8)
            
            Text(NSLocalizedString(Constant.Home.Text.SUB_GUIDE_ADVOCATE, comment: ""))
              .foregroundColor(Color.init(hex: 0x4D5B6A))
              .captionLexend(size: 12)
              .padding(.bottom, 8)
          }
          
          Spacer()
          
          Image("ic_right_arrow", bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
            .aspectRatio(contentMode: .fill)
            .padding(.horizontal, 8)
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: 125,
          alignment: .leading
        )
        .padding(.horizontal, 12)
        .background(Color.init(hex: 0xF3FBFF))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              Color.init(hex: 0xEEF2F7),
              lineWidth: 1
            )
        )
        .onTapGesture {
          onTapDecisionTree()
        }
        
      }
      .frame(minHeight: 50)
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray100)
      
      HStack {
        Image("ic_probono_2", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)
        
        Text(
          NSLocalizedString(
            Constant.Home.Text.BOTTOM_PROBONO_TITLE,
            comment: ""
          )
        )
        .titleLexend(size: 12)
        .padding(.trailing, 12)
        
        Spacer()
        
        Text(store.actionTitle())
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(
        maxWidth: .infinity,
        minHeight: 40,
        alignment: .center
      )
      .background(
        LinearGradient(
          colors: [
            Color.gradientBlue,
            Color.gradientBlue2,
            Color.gradientBlue2
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(
            Color.primaryInfo200,
            lineWidth: 1
          )
      )
      .padding(.bottom, 8)
      .onTapGesture {
        onTapProbono()
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 80)
  }
  
  @ViewBuilder
  func consultationAIBottomSheetContent(
    onTapConsultation: @escaping () -> Void,
    onTapDecisionTree: @escaping () -> Void
  ) -> some View {
    
    VStack(alignment: .leading, spacing: 16) {
      
      VStack(alignment: .leading, spacing: 16) {
        Text(
          NSLocalizedString(
            Constant.Home.Text.CONSULTATION_TITLE,
            comment: ""
          )
        )
        .titleLexend(size: 20)
        
        Text(
          NSLocalizedString(
            Constant.Home.Text.CONSULTATION_SUB_TITLE,
            comment: ""
          )
        )
        .captionLexend(size: 14)
      }
      .frame(minHeight: 30)
      
      VStack(alignment: .leading, spacing: 16) {
        
        ZStack {
          GeometryReader { proxy in
            let frame = proxy.frame(in: .global)
            
            VStack {
              Text("Direkomendasikan")
                .foregroundStyle(Color.white)
                .captionLexend(size: 10)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(
              LinearGradient(
                colors: [Color(hex: 0xFA4D56), Color(hex: 0xFFA8AC)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .clipShape(
              CustomCorner(
                corners: [.topLeft, .topRight, .bottomLeft],
                radius: 16
              )
            )
            .position(x: frame.maxX - 72)
            .zIndex(1)
            
            HStack(alignment: .center, spacing: 8) {
              Image("AI", bundle: .module)
                .resizable()
                .frame(width: 48, height: 48)
                .aspectRatio(contentMode: .fill)
                .padding(.horizontal, 8)
              
              VStack(alignment: .leading, spacing: 4) {
                Text(
                  NSLocalizedString(
                    Constant.Home.Text.AI_CONSULTATION_TITLE,
                    comment: ""
                  )
                )
                .lineLimit(3)
                .titleLexend(size: 14)
                .padding(.top, 8)
                
                Text(
                  NSLocalizedString(
                    Constant.Home.Text.AI_CONSULTATION_SUB_TITLE,
                    comment: ""
                  )
                )
                .lineLimit(3)
                .foregroundStyle(Color.gray600)
                .captionLexend(size: 12)
                .padding(.trailing, 32)
                .padding(.bottom, 8)
              }
              
            }
            .padding(.vertical, 4)
            .frame(
              maxWidth: .infinity,
              minHeight: 100,
              alignment: .leading
            )
            .padding(.horizontal, 12)
            .background(Color.primaryInfo100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(
                  Color.primaryInfo200,
                  lineWidth: 1
                )
            )
            .onTapGesture {
              onTapDecisionTree()
            }
          }
          
        }
        .frame(height: 100)
        
        HStack(spacing: 16) {
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .background(Color.gray100)
          
          Text("Atau")
            .captionLexend(size: 12)
          
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .background(Color.gray100)
        }
        
        HStack(alignment: .center, spacing: 8) {
          Image("search_advocate", bundle: .module)
            .resizable()
            .frame(width: 48, height: 48)
            .aspectRatio(contentMode: .fill)
            .padding(.horizontal, 8)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(
              NSLocalizedString(
                Constant.Home.Text.SHOW_ALL_ADVOCATE,
                comment: ""
              )
            )
            .titleLexend(size: 14)
            .padding(.top, 8)
            
            Text(
              NSLocalizedString(
                Constant.Home.Text.SUB_SHOW_ALL_ADVOCATE,
                comment: ""
              )
            )
            .foregroundColor(Color.gray600)
            .captionLexend(size: 12)
            .lineLimit(3)
            .padding(.bottom, 8)
          }
        }
        .padding(.vertical, 4)
        .frame(
          maxWidth: .infinity,
          minHeight: 80,
          alignment: .leading
        )
        .padding(.horizontal, 12)
        .background(Color.primaryInfo050)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              Color.primaryInfo200,
              lineWidth: 1
            )
        )
        .onTapGesture {
          onTapConsultation()
        }
        
      }
      .frame(minHeight: 80)
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 120)
  }
  
  @ViewBuilder
  func categoryBottomSheetContent(
    models: [AdvocateSkillsTypes],
    selectedModel: AdvocateSkills,
    onTap: @escaping () -> Void
  ) -> some View {
    
    VStack(alignment: .leading, spacing: 16) {
      
      HStack {
        KFImage(selectedModel.getIconName())
          .resizable()
          .frame(width: 50, height: 50)
        
        Text(selectedModel.skillName)
          .titleStyle(size: 14)
      }
      
      ChipLayout(models: models) { model in
        ChipTextView(
          text: model.getName(),
          textColor: Color.buttonActiveColor,
          backgroundColor: Color.primary050
        )
      }
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray100)
      
      Text(selectedModel.getDescriptions())
        .captionStyle(size: 14)
      
      ButtonPrimary(
        title: "Lihat Advokat",
        color: .buttonActiveColor,
        width: .infinity,
        height: 38
      ) {
        onTap()
      }
      
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 85)
  }
  
  @ViewBuilder
  func promotionBanner(
    _ isPresented: Binding<Bool>,
    imageURL: URL?
  ) -> some View {
    
    if isPresented.wrappedValue {
      ZStack {
        Color.black.opacity(0.5)
        
        PromotionBannerView(imageURL: imageURL){
          store.navigateToProbonoService()
        } onTapConsult: {
          store.navigateToAdvocatesFromPopupBanner()
        } onTapBlog: {
          store.navigateToBlog()
        } onTapClose: {
          store.dismissPromotionBanner()
        }
        
      }
      .ignoresSafeArea()
    }
    
  }
  
  private func createDottedText(
    _ string: String,
    underline: Bool = false,
    strikethrough: Bool = false
  ) -> AttributedString {
    var attributedString = AttributedString(string)
    
    _ = NSNumber(value: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue)
    
    if underline {
      attributedString.underlineStyle = Text.LineStyle(pattern: .solid, color: .white)
    }
    
    if strikethrough {
      attributedString.strikethroughStyle = Text.LineStyle(pattern: .solid, color: .white)
    }
    
    return attributedString
  }
  
}

#Preview {
  HomeView(
    store: HomeStore(
      userSessionDataSource: MockUserSessionDataSource(),
      homeRepository: HomeRepositoryImpl(
        remoteDataSource: FakeHomeRemoteDataSource()
      ),
      ongoingRepository: HomeRepositoryImpl(
        remoteDataSource: FakeHomeRemoteDataSource()
      ),
      sktmRepository: HomeRepositoryImpl(
        remoteDataSource: FakeHomeRemoteDataSource()
      ),
      idCardRepository: MockGetKTPRepository(),
      cancelationRepository: MockPaymentRepository(),
      meRepository: MockHomeRepository(),
      legalFormRepository: MockLegalFormRepository(),
      promotionRepository: MockPromotionRepository(),
      onlineAdvocateNavigator: MockNavigator(),
      topAdvocateNavigator: MockNavigator(),
      articleNavigator: MockNavigator(),
      searchNavigator: MockNavigator(),
      categoryNavigator: MockNavigator(),
      advocateListNavigator: MockNavigator(),
      sktmNavigator: MockNavigator(),
      legalFormPaymentNavigator: MockLegalFormNavigator(),
      mainTabBarResponder: MockNavigator(),
      ongoingNavigator: MockNavigator(),
      loginResponder: MockNavigator(),
      refundNavigator: MockNavigator(),
      probonoNavigator: MockNavigator(),
      notaryResponder: MockNavigator(),
      promotionListNavigator: MockNavigator(),
      loginRepository: MockLoginRepository(),
      otpRepository: MockOTPRepository(),
      registerNavigator: MockNavigator()
    )
  )
}
