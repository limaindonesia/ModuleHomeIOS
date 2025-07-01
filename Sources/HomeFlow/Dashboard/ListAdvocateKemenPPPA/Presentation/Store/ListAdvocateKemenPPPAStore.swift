//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 20/06/25.
//


import Foundation
import AprodhitKit
import GnDKit
import Combine
import UIKit
import SwiftUI
import NaturalLanguage

public class ListAdvocateKemenPPPAStore: ObservableObject {
  
  //Dependency
  private let advocateNavigator: OnlineAdvocateNavigator
  private var kemenPPPANavigator: KemenPPPANavigator
  public let userSessionDataSource: UserSessionDataSourceLogic
  public var network: NetworkServiceLogic
  public var viewModel: MainTabbarViewModel
  
  //State
  @Published public var listAdvocates: [Advocate] = []
  @Published public var isPresentSekeleton: Bool = false
  @Published public var isPresentFilter: Bool = false
  @Published public var selectedProvinceTitle: String = "Provinsi"
  @Published public var selectedCityTitle: String = "Kota"
  @Published public var selectedProvinceInt: [Int] = []
  @Published public var selectedCityInt: [Int] = []
  @Published public var provinceList: [ProvincesList] = []
  @Published public var cityList: [CityList] = []
  @Published public var isProvinceFilter: Bool = false
  @Published public var isAllAdvocateOfflane: Bool = false
  @Published public var isAllAdvocateOfflaneAlreadyPressNotif: Bool = false
  @Published public var showLogin: Bool = false
  @Published public var showSnakeBarNotification: Bool = false
  @Published public var userSession: UserSessionData?
  @Published public var isLoadMore: Bool = false
  
  private let listKemenPPPARepositoryLogic: ListKemenPPPARepositoryLogic
  public var isLoading: Bool = false
  public var message: String = ""
  public var limit: Int = 10
  public var skip: Int = 0
  
  public init() {
    self.listKemenPPPARepositoryLogic = MockListKemenPPPARepositoryLogic()
    self.userSessionDataSource = MockUserSessionDataSource()
    self.advocateNavigator = MockNavigator()
    self.network = MockNetworkService()
    self.viewModel = MainTabbarViewModel()
    self.kemenPPPANavigator = MockNavigator()
  }
  
  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    advocateNavigator: OnlineAdvocateNavigator,
    listKemenPPPARepositoryLogic: ListKemenPPPARepositoryLogic,
    kemenPPPANavigator: KemenPPPANavigator,
    network: NetworkServiceLogic,
    viewModel: MainTabbarViewModel,
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.advocateNavigator = advocateNavigator
    self.listKemenPPPARepositoryLogic = listKemenPPPARepositoryLogic
    self.kemenPPPANavigator = kemenPPPANavigator
    self.network = network
    self.viewModel = viewModel
    
    self.isPresentSekeleton = true
    
    Task {
      await fetchAllAPI()
    }
  }
  
  @MainActor
  public func fetchAllAPI() async {
    async let provinceViewModels = fetchFilterProvince()
    async let advocateViewModels = fetchOnlineAdvocates()
    
    provinceList = await provinceViewModels
    listAdvocates = await advocateViewModels
    checkingAllAdvocateStatus()
  }
  
  @MainActor
  public func processLoadMore() async {
    if isLoadMore {
      isLoadMore = false
      
      async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
      
      var listAdvocatesLoadMore: [Advocate] = []
      listAdvocatesLoadMore = await advocateViewModels
      
      for item in listAdvocatesLoadMore {
        if listAdvocates.contains(where: { $0.id == item.id  }) {
          
        } else {
          listAdvocates.append(item)
        }
      }
      checkingAllAdvocateStatus()
    }
  }
  
  //MARK: - API
  
  @MainActor
  public func postAdvocateAvailbility(advocate: Advocate?, index: Int) async -> String {
    var message: String = ""
    let lawyerID = advocate?.getID()
    let username = ((Prefs.getClient()?.phone) != nil) ? Prefs.getClient()?.phone ?? "" : Prefs.getClient()?.email ?? ""
    
    do {
      
      let params = AdvocateAvaibilityRequestParam(clientUsername: username, lawyerID: lawyerID)
      let items = try await listKemenPPPARepositoryLogic.postAdvocateAvailbility(params: params)
      
      if items.count > 0 && items.first?.success == true {
        if advocate == nil {
          self.isAllAdvocateOfflaneAlreadyPressNotif = true
        } else {
          self.listAdvocates[index].isAlreadyPressNotif = true
        }
        message = items.first?.message ?? ""
        showSnakeBarNotification = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          self.showSnakeBarNotification = false
        }
        
      }
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return "" }
//      indicateError(message: error)
    }
    
    return message
  }
  
  @MainActor
  public func fetchOnlineAdvocates() async -> [Advocate] {
    var advocates: [Advocate] = []
    
    do {
      let params = ListKemenPPPARequestParam(isOnline: true, limit: limit, skip: skip, cities: nil, provinces: nil)
      let items = try await listKemenPPPARepositoryLogic.fetchOnlineAdvocates(params: params)
      
      skip = skip + items.count
      advocates = items
      isLoadMore = true
      isPresentSekeleton = false
      
    } catch {
      isPresentSekeleton = false
      guard let error = error as? ErrorMessage
      else { return [] }
//      indicateError(message: error)
    }
    
    return advocates
  }
  
  
  @MainActor
  public func fetchOnlineAdvocatesFilterLoadMore() async -> [Advocate] {
    var advocates: [Advocate] = []
    
    do {
      let params = ListKemenPPPARequestParam(isOnline: true, limit: limit, skip: skip, cities: selectedCityInt, provinces: selectedProvinceInt)
      let items = try await listKemenPPPARepositoryLogic.fetchOnlineAdvocates(params: params)
      
      if !isLoadMore {
        skip = skip + items.count
        isLoadMore = true
      }
      
      advocates = items
      isPresentSekeleton = false
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
      
//      indicateError(message: error)
    }
    
    return advocates
  }
  
  @MainActor
  public func fetchFilterProvince() async -> [ProvincesList] {
    var provinces: [ProvincesList] = []
    do {
      let items = try await listKemenPPPARepositoryLogic.fetchFilterProvince()
      provinces = items
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
//      indicateError(error: error)
    }
    
    return provinces
  }
  
  @MainActor
  public func fetchFilterCity() async -> [CityList] {
    var cities: [CityList] = []
    do {
      let params = FilterCityKemenPPPARequestParam(provinceId: selectedProvinceInt.first ?? 0)
      let items = try await listKemenPPPARepositoryLogic.fetchFilterCity(params: params)
      
      cities = items
      
      print("cityList == \(cityList)")
    } catch {
      guard let error = error as? ErrorMessage
      else { return [] }
//      indicateError(error: error)
    }
    return cities
  }
  
  //MARK: - Other function
  @MainActor
  public func sendNotificationToAllAdvocate() async {
    if isAllAdvocateOfflaneAlreadyPressNotif {
      return
    }
    async let postAdvocateModels = postAdvocateAvailbility(advocate: nil, index: 0)
  }
  
  public func checkingAllAdvocateStatus() {
    if listAdvocates.contains(where: { $0.is_online == true }) {
      isAllAdvocateOfflane = false
    } else {
      isAllAdvocateOfflane = true
    }
  }
  
  @MainActor
  public func setupLogicFilter(provinces: [ProvincesList], cities: [CityList]) async {
    hideBottomSheetFilter()
    
    if provinces.count > 0 {
      for item in provinces {
        selectedProvinceInt.append(item.id ?? 0)
      }
      selectedProvinceTitle = provinces.first?.name ?? ""
      cityList = []
      async let cityViewModels = fetchFilterCity()
      
      cityList = await cityViewModels
    }
    if cities.count > 0 {
      selectedCityInt = []
      for item in cities {
        selectedCityInt.append(item.id ?? 0)
      }
      selectedCityTitle = cities.first?.name ?? ""
    }
    limit = 10
    skip = 0
    isPresentSekeleton = true
    
    listAdvocates = []
    
    async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
    
    var listAdvocateFilter: [Advocate] = []
    listAdvocateFilter = await advocateViewModels
    
    listAdvocates =  listAdvocateFilter
  }
  
  public func onRefresh() {
    limit = 10
    skip = 0
    isPresentSekeleton = true
    provinceList = []
    cityList = []
    selectedProvinceInt = []
    selectedCityInt = []

    Task {
      await fetchAllAPI()
    }
    
  }
  
  @MainActor
  public func processConsulatation(advocate: Advocate) async {
    guard let token = userSession?.remoteSession.remoteToken else {
      showLogin = true
      return
    }
    if advocate.isBusy() {
      return
    } else {
      if advocate.isOnline() {
        navigateToOrderProcess(advocate: advocate)
      } else {
        let index = listAdvocates.firstIndex { i in
          advocate.id == i.id
        }!
        if !listAdvocates[index].isAlreadyPressNotif {
          async let postAdvocateModels = postAdvocateAvailbility(advocate: listAdvocates[index], index: index)
        }
      }
    }
  }
  
  //MARK: - Local
  
  @MainActor
  public func fetchUserSessionData() async {
    do {
      userSession = try await userSessionDataSource.fetchData()
    } catch {
      
    }
  }
  
  
  //MARK: - Navigator
  
  @MainActor
  public func navigateToKemenPPPA() {
    kemenPPPANavigator.navigateToKemenPPPA()
  }
  
  @MainActor
  public func navigateToAdvocateDetail(advocate: Advocate) {
    let index = listAdvocates.firstIndex { i in
      advocate.id == i.id
    }!
    advocateNavigator.navigateToAdvocateDetail(
      index: Int(index),
      advocates: listAdvocates,
      sktmModel: nil,
      isFromDeeplink: false,
      slug: advocate.getSlug(),
      isKemenPPPA: true,
      navigationController: nil
    )
  }
  
  @MainActor
  public func navigateToOrderProcess(advocate: Advocate) {
    let index = listAdvocates.firstIndex { i in
      advocate.id == i.id
    }!
    advocateNavigator.navigateToOrderProcess(
      advocate,
      selectedCategory: CategoryParameter(
        id: index,
        lawyerSkillPriceId:  0,
        skillId: 0,
        name: advocate.name ?? "",
        caseExample: "",
        price:  "",
        originalPrice: "",
        isSelected: true),
      sktmModel: nil
    )
  }
  
  //MARK: - Indicate
  @MainActor
  public func showBottomSheetFilterProvince() {
    isProvinceFilter = true
    isPresentFilter = true
  }
  @MainActor
  public func showBottomSheetFilterCities() {
    isProvinceFilter = false
    isPresentFilter = true
  }
  
  @MainActor
  public func hideBottomSheetFilter() {
    isPresentFilter = false
  }
  
  private func indicateLoading() {
    isLoading = true
  }
  
  private func indicateError(message: String) {
    isLoading = false
    self.message = message
  }
  
  
}
