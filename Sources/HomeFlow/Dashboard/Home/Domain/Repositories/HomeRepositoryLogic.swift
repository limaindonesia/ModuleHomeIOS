//
//  HomeRepositoryLogic.swift
//
//
//  Created by Ilham Prabawa on 19/07/24.
//

import Foundation
import Combine
import GnDKit
import AprodhitKit

public protocol HomeRepositoryLogic {

  func fetchOnlineAdvocates(params: AdvocateParamRequest) async throws -> [Advocate]

  func fetchSkills(params: CategoryParamRequest?) async throws -> [AdvocateSkills]

  func fetchTopAdvocates() async throws -> (TopDataEntity, [TopAdvocateEntity], [TopAgencyEntity])

  func fetchArticles(params: ArticleParamRequest) async throws -> [ArticleEntity]

  func fetchCategoryArticle() async throws -> [CategoryArticleEntity]

  func fetchNewestArticle() async throws -> [ArticleEntity]

  func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases]

  func fetchPaymentStatus(
    headers: [String : String],
    parameters: PaymentStatusRequest
  ) async throws -> PaymentStatusEntity
  
  func fetchPromotionBanner() async throws -> BannerPromotionEntity

}
