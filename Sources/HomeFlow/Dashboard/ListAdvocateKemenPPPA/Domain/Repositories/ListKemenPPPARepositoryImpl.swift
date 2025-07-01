//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import Foundation
import GnDKit
import AprodhitKit

public class ListKemenPPPARepositoryImpl: ListKemenPPPARepositoryLogic {
  
  private let remoteDataSource: ListKemenPPPADataSourceLogic
  
  public init(remoteDataSource: ListKemenPPPADataSourceLogic) {
    self.remoteDataSource = remoteDataSource
  }
  
  public func fetchOnlineAdvocates(
    params: ListKemenPPPARequestParam
  ) async throws -> [Advocate] {
    do {
      let model = try await remoteDataSource.fetchOnlineAdvocates(params: params.toParam())
      return  model.data ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Gagal",
        message: error.description
      )
    }
  }
  
  public func fetchFilterProvince(
  ) async throws -> [ProvincesList] {
    do {
      let model = try await remoteDataSource.fetchFilterProvince()
      
      return model.data ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
    }
  }
  
  public func fetchFilterCity(
    params: FilterCityKemenPPPARequestParam
  ) async throws -> [CityList] {
    do {
      let model = try await remoteDataSource.fetchFilterCity(params.toParam())
      
      return model.data ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          title: "Failed",
          message: "Uknown Failed"
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
      
    }
  }
  
  public func postAdvocateAvailbility(
    params: AdvocateAvaibilityRequestParam
  ) async throws -> [AdvocateAvaibilityGetResp] {
    do {
      let model = try await remoteDataSource.postAdvocateAvailbility(params: params.toParam())
      var arrayModel: [AdvocateAvaibilityGetResp] = []
      arrayModel.append(model)
      return arrayModel
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Gagal",
        message: error.description
      )
    }
  }
  
}
