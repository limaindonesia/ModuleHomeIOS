//
//  ListAdvocateView.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 20/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit
import Lottie
import Kingfisher

public struct ListAdvocateKemenPPPAView: View {
  
  @ObservedObject var store: ListAdvocateKemenPPPAStore
  @State private var reader: ScrollViewProxy?
  @FocusState var isFocused: Bool
  
  private init() {
    self.store = .init()
  }
  
  public init(store: ListAdvocateKemenPPPAStore) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      
      VStack(spacing: 8) {
        Spacer().frame(height: 1)
        
        FilterKemenPPPAView(
          province: store.selectedProvinceTitle,
          city: store.selectedCityTitle,
          selectedCityCount: store.selectedCityInt.count) {
            store.showBottomSheetFilterProvince()
          } onTapCity: {
            store.showBottomSheetFilterCities()
          }

        ScrollViewReader { proxy in
          ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
              LocationInfoView()
              
              KemenPPPABannerView() {
                store.navigateToKemenPPPA()
              }
              .padding(.top, 10)
              
              if store.isAllAdvocateOfflane {
                LawyerOfflineView() {
                  Task {
                    await store.sendNotificationToAllAdvocate()
                  }
                }
              }
              
              loadListAdvocateKemenPPPA(
                listAdvocate: store.listAdvocates,
                onTap: { data in
                  store.navigateToAdvocateDetail(advocate: data)
              }, onTapConsultation: { data in
                Task {
                  await store.processConsulatation(advocate: data)
                }
              })
              .padding(.horizontal, 16)
              
              if store.isLoadMore {
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle())
                  .padding(.vertical, 16)
              }
              
              Color.clear
                .frame(height: 1)
                .background(
                  GeometryReader { geo in
                    Color.clear
                      .preference(key: BottomScrollPreferenceKey.self, value: geo.frame(in: .global).minY)
                  }
                )
              
            }
            .background(Color.gray050)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
          }
          .onAppear {
            self.reader = proxy
          }
        }
        .refreshable {
          store.onRefresh()
        }
        .onPreferenceChange(BottomScrollPreferenceKey.self) { value in
            let screenHeight = UIScreen.main.bounds.height
            if value < screenHeight + 20 {
              Task {
                await store.processLoadMore()
              }
            }
          }
      }
      .ignoresSafeArea(.keyboard)
      .task {
        await store.fetchUserSessionData()
      }
      
      BottomSheetView(isPresented: $store.isPresentFilter) {
        FilterKemenPPPAContentView(
          allProvinces: store.provinceList,
          allCities: store.cityList,
          isProvinceFilter: store.isProvinceFilter,
          onApply: { provinces, cities in
            Task {
              await store.setupLogicFilter(provinces: Array(provinces), cities: Array(cities))
            }
          },
          onDismiss: {
            store.hideBottomSheetFilter()
          }
        )
      }
      
    }
  }
  
  @ViewBuilder
  func loadListAdvocateKemenPPPA(
    listAdvocate: [Advocate],
    onTap: @escaping (Advocate) -> Void,
    onTapConsultation: @escaping (Advocate) -> Void
  ) -> some View {
    ForEach(listAdvocate, id: \.id) { advocate in
      ListInsideAdvocateKemenPPPAView(
          name: advocate.getName(),
          imageName: advocate.getImageName(),
          location: advocate.getLocation(),
          experience: advocate.getExperience(),
          rating: advocate.getRating(),
          totalConsultation: advocate.total_consultations ?? 0,
          isOnline: advocate.is_online ?? false,
          isBusy: advocate.is_busy ?? false,
          isAlreadyPressNotif: advocate.isAlreadyPressNotif) {
            onTap(advocate)
          } onTapConsultation: {
            onTapConsultation(advocate)
          }

    }
  }
  
  
  @ViewBuilder
  func FilterKemenPPPAView(
    province: String,
    city: String,
    selectedCityCount: Int,
    onTapProvince: @escaping () -> Void,
    onTapCity: @escaping () -> Void
  ) -> some View {
    HStack(alignment: .center, spacing: 16) {
      HStack {
        Text(province)
          .foregroundStyle(province == "Provinsi" ? Color.gray500 : Color.primaryInfo700)
          .captionLexend(size: 10)
        
        Image(province == "Provinsi" ? "ic_down_arrow_kemenpppa" : "ic_down_arrow_kemenpppa_blue", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 6, height: 6)
      }
      .frame(height: 24)
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay {
        RoundedRectangle(cornerRadius: 12)
          .stroke((province == "Provinsi" ? Color.gray100 : Color.primaryInfo200), lineWidth: 1)
      }
      .background(province == "Provinsi" ? Color.white : Color.primaryInfo050)
      .onTapGesture {
        onTapProvince()
      }
      
      HStack {
        Text(city)
          .foregroundStyle(city == "Kota" ? Color.gray500 : Color.primaryInfo700)
          .captionLexend(size: 10)
        
        if selectedCityCount > 1 {
          Text("\(selectedCityCount)")
            .frame(width: 12, height: 12)
            .background(Circle().fill(Color.redFilterCity))
            .foregroundStyle(.white)
            .captionLexend(size: 8)
        }
        
        Image(city == "Kota" ? "ic_down_arrow_kemenpppa" : "ic_down_arrow_kemenpppa_blue", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 6, height: 6)
      }
      .frame(height: 24)
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay {
        RoundedRectangle(cornerRadius: 12)
          .stroke((city == "Kota" ? Color.gray100 : Color.primaryInfo200), lineWidth: 1)
      }
      .background(city == "Kota" ? Color.white : Color.primaryInfo050)
      .onTapGesture {
        onTapCity()
      }
      
      Spacer()
    }
    .padding(.leading, 16)
    .padding(.trailing, 16)
  }
  
  
  @ViewBuilder
  func KemenPPPABannerView(
    onTap: @escaping () -> Void
  ) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text("Layanan gratis ini khusus untuk korban kekerasan perempuan & anak")
                        .captionLexend(size: 12)
                        .foregroundStyle(Color.gray900)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                      onTap()
                    }) {
                        Text("Pelajari")
                            .foregroundStyle(Color.primaryInfo700)
                            .titleLexend(size: 12)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.primaryInfo050)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                }

                Divider().background(
                    LinearGradient(
                        colors: [Color.gradient1KemenPPPAHome, Color.gradient2KemenPPPAHome],
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                )

                HStack(spacing: 16) {
                    Image("ic_logo_kemenPPPA", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)

                    Image("ic_logo_peradi", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)

                    Text("|")
                        .foregroundStyle(Color.danger300)
                        .frame(height: 16)

                    Image("ic_logo_perqara", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)

                    Spacer()
                  
                    Spacer()
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.gradient1KemenPPPAHome, Color.gradient2KemenPPPAHome],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.danger200, lineWidth: 1)
            }
            .cornerRadius(12)
            .padding(.horizontal)

          Image("ic_ellipse", bundle: .module)
            .frame(width: 100)
            .frame(maxHeight: 100)
            .clipped()
        }
    }
  
  @ViewBuilder
  func LawyerOfflineView(
    onTap: @escaping () -> Void
  ) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(
          LinearGradient(
            colors: [Color.gradient3KemenPPPAList, Color.white],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .overlay(
          Image("ic_kemenPPPA_supergraphic", bundle: .module)
            .resizable()
            .scaledToFill()
            .clipped()
        )
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical)
        .zIndex(0)
      
      VStack(spacing: 16) {
        HStack(alignment: .top, spacing: 12) {
          Image("ic_kemenPPPA_notif_off", bundle: .module)
            .resizable()
            .frame(width: 48, height: 48)
          
          VStack(alignment: .leading, spacing: 4) {
            Text("Maaf, Advokat sedang Offline")
              .titleLexend(size: 14)
              .foregroundStyle(Color.gray900)
              .padding(.top, -5)
            
            Text("Aktifkan notifikasi pemberitahuan ketika Advokat yang offline tersedia kembali")
              .captionLexend(size: 12)
              .foregroundStyle(Color.gray500)
              .lineLimit(2)
              .multilineTextAlignment(.leading)
              .fixedSize(horizontal: false, vertical: true)
              .lineSpacing(4)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: {
          
        }) {
          HStack(spacing: 8) {
            Image(store.isAllAdvocateOfflaneAlreadyPressNotif ? "ic_notification_kemenPPPA_green": "ic_notification_kemenPPPA_blue", bundle: .module)
              .resizable()
              .frame(width: 20, height: 20)
            
            Text(store.isAllAdvocateOfflaneAlreadyPressNotif ? "Notifikasi Aktif" : "Aktifkan Notifikasi")
              .foregroundStyle(store.isAllAdvocateOfflaneAlreadyPressNotif ? Color.success700 : Color.primaryInfo700)
              .titleLexend(size: 12)
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(store.isAllAdvocateOfflaneAlreadyPressNotif ? Color.success050 : Color.clear)
          )
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(store.isAllAdvocateOfflaneAlreadyPressNotif ? Color.success500 : Color.primaryInfo600, lineWidth: 1)
          )
          .clipped()
          .onTapGesture {
            onTap()
          }
        }
      }
      .padding()
      .background(Color.clear)
      .cornerRadius(12)
      .padding(.horizontal, 16)
      .padding(.vertical)
      .zIndex(1)
    }
  }
}

struct LocationInfoView: View {
    var body: some View {
      HStack(alignment: .center, spacing: 16) {
        Image("ic_filter_map_kemenpppa", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)
        
        Text("Filter advokat sesuai domisili Anda untuk kemudahan pendampingan.")
          .captionLexend(size: 12)
          .foregroundColor(Color.gray700)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(Color.primary100)
      .cornerRadius(8)
      
    }
}


struct BottomScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
