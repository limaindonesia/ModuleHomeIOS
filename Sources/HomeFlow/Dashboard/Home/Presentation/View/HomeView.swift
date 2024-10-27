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

public struct HomeView: View {

  @ObservedObject var store: HomeStore
  @State var offSet: CGFloat = 0
  @State var isRefreshing: Bool = false
  @State var refresh: Refresh = Refresh(
    started: false,
    released: false
  )

  public init(store: HomeStore) {
    self.store = store
  }

  public var body: some View {
    ZStack {

      loadContent()
      
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

      promotionBanner($store.isPresentPromotionBanner)

      if store.isLoading {
        BlurView(style: .dark)

        LottieView {
          LottieAnimation.named("waiting-approval", bundle: .module)
        }
        .looping()
      }

    }
    .ignoresSafeArea(edges: .top)
  }

  @ViewBuilder
  func loadContent() -> some View {
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
  func homeContentView() -> some View {
    VStack {
      navigationBarView()
        .zIndex(1)

      CustomScrollView(
        isRefreshing: $isRefreshing,
        refreshState: $refresh
      ) {

        VStack(spacing: 32) {

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

            sktmNewView(
              onTapDecisionTree: {
                store.navigateToDecisionTree()
              }, onTapConsultation: {
                store.navigateToAdvocateList()
              }, onTapSKTM: {
                store.navigateToDetailSKTM()
              }
            ).padding(.top, 340)

            activeAdvocates(store.onlinedAdvocates)
          }

          gridCategory(
            store.showCategories,
            onTap: { skill in
              store.selectedSkill = skill
              store.showCategoryBottomSheet()
            }
          )

          topAdvocatesNew(
            store.getFourTopAdvocates(),
            month: store.topAdvocateMonth,
            onTap: { store.navigateToDetailTopAdvocate() }
          )
          .frame(height: 230)

          lawArticles(
            categories: store.categories,
            articles: store.articles,
            selectedID: store.articleSelectedID
          )
          .padding(.bottom, 80)

        }

      } onRefresh: {
        Task {
          await store.onRefresh()
          isRefreshing = false
          refresh.started = false
          refresh.released = false
        }
      }
      .background(Color.gray050)
      .padding(.top, -20)
      .padding(.bottom, 80)

    }
    .onAppear {
      Task {
        await store.fetchOngoingUserCases()
      }
    }
  }

  @ViewBuilder
  func navigationBarView() -> some View {
    VStack {
      Text("")
    }
    .frame(maxWidth: .infinity, minHeight: 44)
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

        Image("bg_home", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(height: 264)
          .position(x: frame.midX, y: 250)
          .zIndex(0)
          .onTapGesture {
            store.navigateToAdvocateList()
          }

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
  func ongoingView(_ item: UserCases) -> some View {
    
    if item.status == Constant.Home.Text.WAITING_FOR_PAYMENT
        || item.status == Constant.Home.Text.ORDER_PENDING {
      
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
          store.navigateToWaitingRoom()
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
          store.navigateToWaitingRoom()
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
  func sktmNewView(
    onTapDecisionTree: @escaping () -> Void,
    onTapConsultation: @escaping () -> Void,
    onTapSKTM: @escaping () -> Void
  ) -> some View {
    VStack(alignment: .center, spacing: 12) {

      HStack(alignment: .center, spacing: 8) {

        Image("ic_moto", bundle: .module)
          .resizable()
          .frame(width: 52.96, height: 25.83)
          .aspectRatio(contentMode: .fit)
          .padding(.trailing, 12)

        VStack(alignment: .leading, spacing: 4) {
          Text("Konsultasi Hukum Online")
            .titleStyle(size: 16)
          Text("Rasakan BEBASnya konsultasi hukum via chat, voice call atau video call.")
            .captionStyle(size: 12)
            .padding(.trailing, 12)
        }
      }
      .padding(.horizontal, 10)

      HStack {
        PositiveButton(
          title: "Panduan Pilih Advokat",
          action: {
            onTapDecisionTree()
          }
        )

        NegativeButton(
          title: "Konsultasi Langsung",
          action: {
            onTapConsultation()
          }
        )
      }
      .padding(.horizontal, 10)
      .padding(.top, 12)

      Button {
        onTapSKTM()
      } label: {
        HStack {
          Image("ic_probono", bundle: .module)

          Text("Dapatkan 3x konsultasi gratis dengan Pro bono")
            .titleStyle(size: 10)

          Spacer()

          Image(systemName: "arrow.forward")
            .resizable()
            .frame(width: 10.67, height: 10.67)
            .foregroundColor(.black)
        }
        .padding(.horizontal, 8)

      }
      .frame(maxWidth: .infinity, maxHeight: 24)
      .background(Color.danger100)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(
            Color.danger200,
            lineWidth: 1
          )
      )
      .padding(.horizontal, 10)

    }
    .frame(maxWidth: .infinity, minHeight: 166)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .gray200, radius: 10, x: 0, y: 15)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  func activeAdvocates(_ items: [Advocate]) -> some View {

    if store.showOnlineAdvocates {
      VStack(spacing: 8) {

        HStack {
          Text(
            NSLocalizedString(
              Constant.Home.Text.ONLINE_ADVOCATE,
              comment: ""
            )
          )
          .foregroundColor(Color.black)
          .bodyStyle(size: 20)

          Spacer()

          SeeAllView(text: Constant.Home.Text.SEE_ALL) {
            store.navigateToSeeAllAdvocate()
          }
        }
        .padding(.horizontal, 16)

        Spacer()

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(items, id: \.id) { advocate in
              AdvocateOnlineRow(
                name: advocate.getName(),
                imageName: advocate.getImageName(),
                experience: advocate.getExperience(),
                rating: advocate.getRating(),
                totalConsultation: advocate.getTotalConsultation(),
                price: advocate.getPrice(),
                originalPrice: advocate.getOriginalPrice(),
                isDiscount: advocate.isDiscount,
                
                isProbono: advocate.isProbono,
                onTap: {
                  store.navigateToDetailAdvocate(advocate)
                },
                onTapConsultation: {}
              )
            }
          }
          .padding(.horizontal, 16)
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
                  .frame(height: 80)
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
                .frame(width: 150)
            }
            .onTapGesture {
              store.navigateToDetailArticle(id: item.id)
            }

          }
        }
        .padding(.horizontal, 16)
      }

    }

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
    .padding(.bottom, 85)
  }

  @ViewBuilder
  func promotionBanner(_ isPresented: Binding<Bool>) -> some View {
    if isPresented.wrappedValue {
      ZStack {
        Color.black.opacity(0.5)

        PromotionBannerView {
          store.navigateToDetailSKTM()
        } onTapConsult: {
          store.navigateToAdvocateList()
        } onTapClose: {
          store.dismissPromotionBanner()
        }

      }
      .ignoresSafeArea()
    }
  }

}

#Preview {
  HomeView(
    store: HomeStore(
      userSessionDataSource: MockUserSessionDataSource(),
      repository: HomeRepositoryImpl(
        remoteDataSource: FakeHomeRemoteDataSource()
      ),
      sktmRepository: HomeRepositoryImpl(
        remoteDataSource: FakeHomeRemoteDataSource()
      ),
      onlineAdvocateNavigator: MockNavigator(),
      topAdvocateNavigator: MockNavigator(),
      articleNavigator: MockNavigator(),
      searchNavigator: MockNavigator(),
      categoryNavigator: MockNavigator(),
      advocateListNavigator: MockNavigator(),
      sktmNavigator: MockNavigator(),
      mainTabBarResponder: MockNavigator(), 
      ongoingNavigator: MockNavigator(), 
      loginResponder: MockNavigator()
    )
  )
}
