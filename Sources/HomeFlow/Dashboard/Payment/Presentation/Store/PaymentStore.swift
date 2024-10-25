//
//  PaymentStore.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import Foundation
import AprodhitKit

public class PaymentStore: ObservableObject {

  //Dependency
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let lawyerInfoViewModel: LawyerInfoViewModel
  private let orderProcessRepository: OrderProcessRepositoryLogic
  private let paymentRepository: PaymentRepositoryLogic

  @Published var isPresentVoucherBottomSheet: Bool = false

  private var userSessionData: UserSessionData?

  public init(
    userSessionDataSource: UserSessionDataSourceLogic,
    lawyerInfoViewModel: LawyerInfoViewModel,
    orderProcessRepository: OrderProcessRepositoryLogic,
    paymentRepository: PaymentRepositoryLogic
  ) {
    self.userSessionDataSource = userSessionDataSource
    self.lawyerInfoViewModel = lawyerInfoViewModel
    self.orderProcessRepository = orderProcessRepository
    self.paymentRepository = paymentRepository
    self.isPresentVoucherBottomSheet = isPresentVoucherBottomSheet
  }

  //MARK: - Fetch API

  public func requestOrderByNumber() async {
    let headers = HeaderRequest(token: userSessionData?.remoteSession.remoteToken)
    let parameters = OrderNumberParamRequest(orderNumber: lawyerInfoViewModel.orderNumber)
    let _ = try? await paymentRepository.requestOrderByNumber(headers, parameters)
  }

  //MARK: - Other function
  
  private func fetchUserSession() async {
    do {
      userSessionData = try await userSessionDataSource.fetchData()
    } catch {
      GLogger(
        .info,
        layer: "Presentation",
        message: error
      )
    }
  }

  //MARK: - Indicate

  public func showVoucherBottomSheet() {
    isPresentVoucherBottomSheet = true
  }

  public func hideVoucherBottomSheet() {
    isPresentVoucherBottomSheet = false
  }

}
