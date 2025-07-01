//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import Foundation
import AprodhitKit
import GnDKit
import Combine

public protocol ListKemenPPPADataSourceLogic {
  
  func fetchOnlineAdvocates(
    params: [String: Any]
  ) async throws -> AdvocateGetResp
  
  func fetchFilterProvince(
  ) async throws -> ProvincesListGetResp
  
  func fetchFilterCity(
    _ parameters: [String : Any]
  ) async throws -> CityListGetResp
  
  func postAdvocateAvailbility(
    params: [String: Any]
  ) async throws -> AdvocateAvaibilityGetResp 
}

public struct ListKemenPPPARemoteDataSourceImpl: ListKemenPPPADataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchOnlineAdvocates(
    params: [String: Any]
  ) async throws -> AdvocateGetResp {
    
    let data = try await service.request(
      with: Endpoint.LAWYER_LIST,
      withMethod: .post,
      withHeaders: nil,
      withParameter: params,
      withEncoding: .json
    )
    
    do {
      let json = try JSONDecoder().decode(AdvocateGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  public func fetchFilterProvince(
  ) async throws -> ProvincesListGetResp {
    do {
      let data = try await service.request(
        with: Endpoint.PROVINCE,
        withMethod: .get,
        withHeaders: nil,
        withParameter: nil,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(ProvincesListGetResp.self, from: data)
      return json
    } catch {
      throw error
    }

  }
  
  public func fetchFilterCity(
    _ parameters: [String : Any]
  ) async throws -> CityListGetResp {
    do {
      let data = try await service.request(
        with: Endpoint.CITIES,
        withMethod: .get,
        withHeaders: nil,
        withParameter: parameters,
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(CityListGetResp.self, from: data)
      return json
    } catch {
      throw error
    }

  }
  
  public func postAdvocateAvailbility(
    params: [String: Any]
  ) async throws -> AdvocateAvaibilityGetResp {
    
    let data = try await service.request(
      with: Endpoint.LAWYERS_AVAILBILITY,
      withMethod: .post,
      withHeaders: nil,
      withParameter: params,
      withEncoding: .json
    )
    
    do {
      let json = try JSONDecoder().decode(AdvocateAvaibilityGetResp.self, from: data)
      return json
    } catch {
      throw error
    }
    
  }
  
  
}
