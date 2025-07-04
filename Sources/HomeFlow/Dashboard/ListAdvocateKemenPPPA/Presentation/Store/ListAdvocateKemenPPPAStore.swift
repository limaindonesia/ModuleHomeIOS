//
//  ListAdvocateKemenPPPAStore.swift
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
  @Published public var listAdvocatesFilterStatus: [Advocate] = []
  @Published public var listAdvocates: [Advocate] = []
  @Published public var isPresentSekeleton: Bool = false
  @Published public var isPresentFilter: Bool = false
  @Published public var searchName: String = ""
  @Published public var selectedProvinceTitle: String = "Provinsi"
  @Published public var selectedCityTitle: String = "Kota"
  @Published public var selectedProvinceInt: [Int] = []
  @Published public var selectedCityInt: [Int] = []
  @Published public var selectedProvinceList: [ProvincesList] = []
  @Published public var selectedCityList: [CityList] = []
  @Published public var provinceList: [ProvincesList] = []
  @Published public var cityList: [CityList] = []
  @Published public var isProvinceFilter: Bool = false
  @Published public var isListAdvocateEmpty: Bool = false
  @Published public var isAllAdvocateOfflane: Bool = false
  @Published public var isAllAdvocateOfflaneAlreadyPressNotif: Bool = false
  @Published public var showLogin: Bool = false
  @Published public var isSearchActive: Bool = false
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
    viewModel: MainTabbarViewModel
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
    async let cityViewModels = fetchFilterCity()
    async let advocateViewModels = fetchOnlineAdvocates()
    
    provinceList = await provinceViewModels
    cityList = await cityViewModels
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
      
      let joinedArray = joinArrays(in: listAdvocates, with: listAdvocatesLoadMore)
      let resultWithNils = removeDuplicatesRecursively(joinedArray)
      let finalResult = preserveOriginalIndices(resultWithNils)

      listAdvocates = finalResult.sorted { $0.is_online! && !$1.is_online! }
      
      checkingAllAdvocateStatus()
    }
  }
  
  private func removeDuplicatesRecursively(
    _ array: [Advocate],
    _ seen: Set<Advocate> = [],
    _ index: Int = 0
  ) -> [Advocate] {
    if index >= array.count {
      return []
    }

    let currentElement = array[index]

    if seen.contains(currentElement) {
      return [] + removeDuplicatesRecursively(array, seen, index + 1)
    } else {
      return [currentElement] + removeDuplicatesRecursively(array, seen.union([currentElement]), index + 1)
    }
  }

  private func preserveOriginalIndices(_ array: [Advocate?]) -> [Advocate] {
    return array.compactMap { $0 }
  }
  
  private func joinArrays(
    in array1: [Advocate],
    with array2: [Advocate]
  ) -> [Advocate] {

    var joinedArray = array1 + array2

    for i in 0..<min(array1.count, array2.count) {
      if array1[i].id == array2[i].id {
        joinedArray[i] = array2[i]
      }
    }

    return joinedArray

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
      
    }
    
    return message
  }
  
  @MainActor
  public func fetchOnlineAdvocates() async -> [Advocate] {
    var advocates: [Advocate] = []
    
    do {
      let params = ListKemenPPPARequestParam(limit: limit, skip: skip, cities: nil, provinces: nil, userName: searchName)
      let items = try await listKemenPPPARepositoryLogic.fetchOnlineAdvocates(params: params)
      
      skip = skip + items.count
      advocates = items
      isLoadMore = true
      isPresentSekeleton = false
      
    } catch {
      isPresentSekeleton = false
    }
    
    return advocates
  }
  
  
  @MainActor
  public func fetchOnlineAdvocatesFilterLoadMore() async -> [Advocate] {
    var advocates: [Advocate] = []
    
    do {
      let params = ListKemenPPPARequestParam(limit: limit, skip: skip, cities: selectedCityInt, provinces: selectedProvinceInt, userName: searchName)
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
      
    }
    return cities
  }
  
  //MARK: - Other function
  
  @MainActor
  public func sendNotificationToAllAdvocate() async {
    guard let token = userSession?.remoteSession.remoteToken else {
      showLogin = true
      return
    }
    if isAllAdvocateOfflaneAlreadyPressNotif {
      return
    }
    
    async let postAdvocateModels = postAdvocateAvailbility(advocate: nil, index: 0)
  }
  
  public func checkingAllAdvocateStatus() {
    if listAdvocates.contains(where: { $0.is_online == true }) {
      isAllAdvocateOfflane = false
    } else {
      isAllAdvocateOfflane = isListAdvocateEmpty ? false : true
    }
    
    isListAdvocateEmpty = listAdvocates.count == 0 ? true : false
  }
  
  @MainActor
  public func setupLogicSearchEmpty() async {
    await onRefresh()
  }
  
  @MainActor
  public func setupLogicSearch() async {
    limit = 10
    skip = 0
    isPresentSekeleton = true
    
    listAdvocates = []
    listAdvocatesFilterStatus = []
    
    async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
    
    var listAdvocateFilter: [Advocate] = []
    listAdvocateFilter = await advocateViewModels
    
    listAdvocatesFilterStatus = listAdvocateFilter
    
    let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
    let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
    let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

    listAdvocates = onlineAvailable + busyOnly + offline
  }
  
  @MainActor
  public func resetFilterProvince() async {
    if selectedProvinceList.count > 0 {
      limit = 10
      skip = 0
      
      selectedProvinceTitle = "Provinsi"
      selectedProvinceInt.removeAll()
      selectedProvinceList.removeAll()
      
      listAdvocates = []
      listAdvocatesFilterStatus = []
      cityList = []
      
      async let cityViewModels = fetchFilterCity()
      cityList = await cityViewModels
      
      async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
      
      var listAdvocateFilter: [Advocate] = []
      listAdvocateFilter = await advocateViewModels
      
      listAdvocatesFilterStatus = listAdvocateFilter
      
      let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
      let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
      let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

      listAdvocates = onlineAvailable + busyOnly + offline
    }
  }
  
  @MainActor
  public func resetFilterCities() async {
    if selectedCityList.count > 0 {
      limit = 10
      skip = 0
      
      selectedCityTitle = "Kota"
      selectedCityInt.removeAll()
      selectedCityList.removeAll()
      
      listAdvocates = []
      listAdvocatesFilterStatus = []
      
      async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
      
      var listAdvocateFilter: [Advocate] = []
      listAdvocateFilter = await advocateViewModels
      
      listAdvocatesFilterStatus = listAdvocateFilter
      
      let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
      let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
      let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

      listAdvocates = onlineAvailable + busyOnly + offline
    }
  }
  
  @MainActor
  public func setupLogicFilter(provinces: [ProvincesList], cities: [CityList]) async {
    hideBottomSheetFilter()
    selectedProvinceList = provinces
    selectedCityList = cities
    
    if provinces.count > 0 {
      selectedProvinceInt = []
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
    listAdvocatesFilterStatus = []
    
    async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
    
    var listAdvocateFilter: [Advocate] = []
    listAdvocateFilter = await advocateViewModels
    
    listAdvocatesFilterStatus = listAdvocateFilter
    
    let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
    let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
    let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

    listAdvocates = onlineAvailable + busyOnly + offline
    
    checkingAllAdvocateStatus()
    
    
  }
  
  @MainActor
  public func onRefresh() async {
    limit = 10
    skip = 0
    isListAdvocateEmpty = isSearchActive ? false : isListAdvocateEmpty
    isPresentSekeleton = true
    
    listAdvocates = []
    listAdvocatesFilterStatus = []
    
    
    if selectedProvinceList.count > 0 || selectedCityList.count > 0 {
      async let advocateViewModels = fetchOnlineAdvocatesFilterLoadMore()
      listAdvocatesFilterStatus = await advocateViewModels
      
      let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
      let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
      let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

      listAdvocates = onlineAvailable + busyOnly + offline
      
    } else {
      async let advocateViewModels = fetchOnlineAdvocates()
      listAdvocatesFilterStatus = await advocateViewModels
      
      let onlineAvailable = listAdvocatesFilterStatus.filter { $0.is_online == true && $0.is_busy == false }
      let busyOnly = listAdvocatesFilterStatus.filter { $0.is_busy == true }
      let offline = listAdvocatesFilterStatus.filter { $0.is_online == false }

      listAdvocates = onlineAvailable + busyOnly + offline
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
  
  private func checkingEducation(advocate: Advocate) -> Bool  {
    var education = ""
    let s3 = advocate.educations.filter { $0?.degree == "S3" }
    let s2 = advocate.educations.filter { $0?.degree == "S2" }
    let s1 = advocate.educations.filter { $0?.degree == "S1" }
    
    if !s3.isEmpty {
      education = s3[0]?.institution_name ?? ""
    } else if !s2.isEmpty {
      education = s2[0]?.institution_name ?? ""
    } else if !s1.isEmpty{
      education = s1[0]?.institution_name ?? ""
    }
    return education == "" ? false : true
  }
  
  private func checkingDescriptions(advocate: Advocate) -> Bool  {
    var description = ""
    description = advocate.description ?? ""
    return description == "" ? false : true
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
    if checkingEducation(advocate: advocate) && checkingDescriptions(advocate: advocate) {
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
    
  }
  
  @MainActor
  public func navigateToOrderProcess(advocate: Advocate) {
    let index = listAdvocates.firstIndex { i in
      advocate.id == i.id
    }!
    advocateNavigator.navigateToOrderProcessKemenPPPA(
      advocate,
      selectedCategory: CategoryParameter(
        id: index,
        lawyerSkillPriceId:  0,
        skillId: 0,
        name: advocate.name ?? "",
        caseExample: "",
        price:  "",
        originalPrice: "",
        isSelected: true
      )
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
