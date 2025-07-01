//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import Foundation
import Combine
import GnDKit
import AprodhitKit

public protocol ListKemenPPPARepositoryLogic {
  
  func fetchOnlineAdvocates(params: ListKemenPPPARequestParam) async throws -> [Advocate]
  func fetchFilterProvince() async throws -> [ProvincesList]
  func fetchFilterCity(params: FilterCityKemenPPPARequestParam) async throws -> [CityList]
  func postAdvocateAvailbility(params: AdvocateAvaibilityRequestParam) async throws -> [AdvocateAvaibilityGetResp]
}
