//
//  DashboardUIView.swift
//
//
//  Created by Ilham Prabawa on 28/10/23.
//

import SwiftUI
import GnDKit
import AprodhitKit
import Lottie
import Combine

/*public struct HomeUIView: View {

  @ObservedObject var store: HomeStore
  @State var offSet: CGFloat = 0
  @State var isRefreshing: Bool = false
  @State var refresh: Refresh = Refresh(
    started: false,
    released: false
  )
  
  let maxHeight = screen.height < 750
  ? (screen.height / 1.9)
  : (screen.height / 2.3)
  
  public init() {
    store = HomeStore(
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
  }
  
  public init(store: HomeStore) {
    self.store = store
  }
  
  public var body: some View {
    
    ZStack {
      
      CustomScrollView(
        isRefreshing: $isRefreshing,
        refreshState: $refresh
      ) {
        
        VStack(spacing: 32) {
          
          headerView()
          
          SKTMView()
          
          //          activeAdvocates(store.onlinedAdvocates)
          
          gridCategory(store.showCategories)
          
          if !store.topAdvocates.isEmpty && !store.topAgencies.isEmpty {
            topView()
              .padding(.vertical, 12)
              .background(Color(hex: 0xE1F2F8))
              .padding(.top, 32)
          }
          
        }
        .onAppear {
          Task {
            await store.fetchAllAPI()
          }
        }
        
      } onRefresh: {
        Task {
          await store.fetchAllAPI()
          isRefreshing = false
          refresh.started = false
          refresh.released = false
        }
      }
      .coordinateSpace(name: "SCROLL")
      
      //      bannerUnauthorized()
      
      BottomSheetView(isPresented: $store.isPresentSheet) {
        VStack(spacing: 16) {
          Text("This is a bottom sheet")
          Text("It adapts to its content size")
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
          Button("Close") {
            store.isPresentSheet.toggle()
          }
        }
        .frame(maxWidth: .infinity)
      }
      
    }
    .edgesIgnoringSafeArea(.top)
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
  func headerView() -> some View {
    ZStack {
      GeometryReader { geo in
        
        VStack(alignment: .leading) {
          
          Text("Selamat Siang,")
            .foregroundColor(.white)
            .captionStyle(size: 24)
          
          Text("Leonardus Wiliem!")
            .foregroundColor(.white)
            .titleStyle(size: 26)
          
          Text("Cari advokat")
            .foregroundColor(.white)
            .captionStyle(size: 14)
            .padding(.top, 24)
            .padding(.bottom, 8)
          
          SearchView()
          
        }
        .frame(height: getHeaderHeight(), alignment: .center)
        .padding(.horizontal, 16)
        .background(
          LinearGradient(
            colors: [
              Color.buttonActiveColor,
              Color(hex: 0x71BCE4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 32))
      }
      .frame(height: 300)
      .offset(y: -offSet)
    }
    .zIndex(offSet < -80 ? 1 : 0)
    //    .modifier(OffsetModifier(offset: $offSet))
    
  }
  
  @ViewBuilder
  func SKTMView() -> some View {
    VStack {
      
      HStack(alignment: .top) {
        
        Image("ic_chat", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 48, height: 48)
          .foregroundColor(.buttonActiveColor)
          .clipped(antialiased: true)
        
        VStack(alignment: .leading) {
          
          Text("Konsultasikan Masalah Hukum")
            .foregroundColor(.darkTextColor)
            .titleStyle(size: 16)
          
          Text("Bersama Peqara, bisa konsultasi hukum kapan pun dan di mana pun")
            .foregroundColor(.darkTextColor)
            .captionStyle(size: 14)
          
          HStack(alignment: .firstTextBaseline) {
            Text("Ajukan layanan Pro bono?")
              .foregroundColor(.lightTextColor)
              .captionStyle(size: 12)
              .padding(.top, 8)
            
            Button {
              
            } label: {
              Text("Lihat detail")
                .foregroundColor(.buttonActiveColor)
                .bodyStyle(size: 12)
            }
          }
        }
        
      }
      .padding(.horizontal, 12)
      .padding(.top, 12)
      
      ButtonPrimary(
        title: "Panduan Pilih Advokat",
        color: Color.buttonActiveColor,
        width: .infinity,
        height: 32
      ) {
        
      }
      .padding(.horizontal, 15)
      .padding(.top, 16)
      
      ButtonSecondary(
        title: "Lihat Daftar Advokat",
        backgroundColor: .clear,
        tintColor: Color.buttonActiveColor,
        width: .infinity,
        height: 32
      ) {
        
      }
      .padding(.horizontal, 15)
      .padding(.bottom, 12)
    }
    .frame(height: 220)
    .background(Color.primary050)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue))
    .padding(.horizontal, 15)
  }
  
  @ViewBuilder
  func activeAdvocates(_ items: [AdvocateViewModel]) -> some View {
    
    if store.showOnlineAdvocates {
      VStack {
        HStack(spacing: 8) {
          Circle()
            .fill(Color(hex: 0x82F665))
            .frame(width: 15, height: 15)
          
          HStack {
            Text(
              NSLocalizedString(
                Constant.Home.Text.NOW_ONLINE,
                comment: ""
              )
            )
            .foregroundColor(Color.black)
            .bodyStyle(size: 20)
            
            Spacer()
            
            SeeAllView(text: "Lihat Semua") {
              
            }
          }
          
          Spacer()
        }
        .padding(.leading, 16)
        
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
                onTap: {
                  
                }
              )
            }
          }
          .padding(.horizontal, 16)
          .animation(.spring(duration: 0.5, blendDuration: 0.6))
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
  func gridCategory(_ show: Bool) -> some View {
    if show {
      VStack {
        
        HStack {
          Text("Pilih dari Kategori")
            .bodyStyle(size: 20)
          
          Spacer()
          
          SeeAllView(text: "Selengkapnya") {
            
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
                iconName: skill.getIconName(by: skill.getID()),
                skillName: skill.skillName,
                subSkillName: skill.getType(),
                additionalCount: skill.getAdditionalCount()
              )
            }
          }
        )
        .id("CATEGORY_GRID")
        .padding(.horizontal, 10)
      }
      .background(Color.white)
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
  func lawArticles() -> some View {
    
  }
  
  private func getHeaderHeight() -> CGFloat {
    let topHeight = 400 + offSet
    return topHeight > 100 ? topHeight : 100
  }
  
}

struct HomeUIVIew_PreviewView: PreviewProvider {
  static var previews: some View {
    HomeUIView(
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
}*/

/*struct OffsetModifier: ViewModifier {
 
 
 @Binding var offset: CGFloat
 
 func body(content: Content) -> some View {
 content
 .overlay(
 GeometryReader { proxy -> Color in
 let minY = proxy.frame(in: .named("SCROLL")).minY
 
 DispatchQueue.main.async {
 self.offset = minY
 }
 
 return Color.clear
 },
 alignment: .top
 )
 }
 
 }*/
