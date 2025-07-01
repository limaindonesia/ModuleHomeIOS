//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//

import AprodhitKit

public class MockListKemenPPPARepositoryLogic: ListKemenPPPARepositoryLogic {
  
  public func fetchOnlineAdvocates(params: ListKemenPPPARequestParam) async throws -> [Advocate] {
    return []
  }
  
  public func fetchFilterProvince() async throws -> [ProvincesList] {
    return []
  }
  
  public func fetchFilterCity(params: FilterCityKemenPPPARequestParam) async throws -> [CityList] {
    return []
  }
  
  public func postAdvocateAvailbility(params: AdvocateAvaibilityRequestParam) async throws -> [AdvocateAvaibilityGetResp] {
    return []
  }
  
}
