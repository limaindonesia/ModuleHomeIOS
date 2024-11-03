//
//  HomeRepositoryImpl.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine

public struct HomeRepositoryImpl: HomeRepositoryLogic, SKTMRepositoryLogic {

  private let remoteDataSource: HomeRemoteDataSourceLogic & SKTMRemoteDataSourceLogic

  public init (remoteDataSource: HomeRemoteDataSourceLogic & SKTMRemoteDataSourceLogic) {
    self.remoteDataSource = remoteDataSource
  }

  public func fetchOnlineAdvocates(
    params: AdvocateParamRequest
  ) async throws -> [Advocate] {
    do {
      let model = try await remoteDataSource.fetchOnlineAdvocates(params: params.toParam())
      return model.data ?? []
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

  public func fetchSkills(
    params: CategoryParamRequest?
  ) async throws -> [AdvocateSkills] {
    do {
      let response = try await remoteDataSource.fetchSkills(params: params?.toParam())
      return response.data
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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchTopAdvocates() async throws -> (TopDataEntity, [TopAdvocateEntity], [TopAgencyEntity]) {
    do {
      let response = try await remoteDataSource.fetchTopAdvocates()
      let advocates = response.data?.lawyers?.map(TopAdvocateEntity.mapFrom(_:)) ?? []
      let agencies = response.data?.agencies?.map(TopAgencyEntity.map(from:)) ?? []
      let data = response.data.map {
        TopDataEntity(
          month: $0.month ?? 0,
          year: $0.year ?? 0
        )
      } ?? .init(month: 0, year: 0)

      return (data, advocates, agencies)

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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchCategoryArticle() async throws -> [CategoryArticleEntity] {
    do {
      let response = try await remoteDataSource.fetchCategoryArticle()
      let entities = response.data?.map(CategoryArticleEntity.map(from:)) ?? []
      return entities
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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchArticles(
    params: ArticleParamRequest
  ) async throws -> [ArticleEntity] {
    do {
      let response = try await remoteDataSource.fetchArticles(params: params.toParam())
      let entities = response.data?.map(ArticleEntity.map(from:)) ?? []
      return entities
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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchNewestArticle() async throws -> [ArticleEntity] {
    do {
      let response = try await remoteDataSource.fetchNewestArticle()
      let entities = response.map(ArticleEntity.map(from:))
      return entities
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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchSKTM(
    headers: [String : String]
  ) async throws -> ClientGetSKTM {
    do {
      let response = try await remoteDataSource.fetchSKTM(headers: headers)
      return response
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
        title: "Failed",
        message: error.description
      )
    }
  }

  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {

    do {

      let response = try await remoteDataSource.fetchOngoingUserCases(
        headers: headers,
        parameters: parameters.toParam()
      )

      return response.data

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
        title: "Failed",
        message: error.description
      )
    }

  }

  public func fetchPaymentStatus(
    headers: [String : String],
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity {

    do {
      let response = try await remoteDataSource.fetchPaymentStatus(
        headers: headers,
        parameters: parameters.toParam()
      )

      guard let data = response.data else { fatalError() }
      return PaymentStatusEntity.map(from: data)

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
        title: "Failed",
        message: error.description
      )
    }

  }

  public func fetchPromotionBanner() async throws -> BannerPromotionEntity {
    do {
      let response = try await remoteDataSource.fetchPromotionBanner()

      guard let data = response.data else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: "Unknown Error"
        )
      }
      
      return BannerPromotionEntity.map(from: data)

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
        title: "Failed",
        message: error.description
      )
    }

  }
  
}
