//
//  MockPaymentRepository.swift
//
//
//  Created by Ilham Prabawa on 25/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct MockPaymentRepository: PaymentRepositoryLogic,
                                     OngoingRepositoryLogic,
                                     PaymentCancelationRepositoryLogic {
  public init() {}
  
  public func requestOrderByNumber(
    _ headers: HeaderRequest,
    _ parameters: OrderNumberParamRequest
  ) async throws -> OrderEntity {
    
    return OrderEntity(
      consultationID: -8,
      lawyerFee: .init(),
      adminFee: .init(),
      discountFee: .init(),
      voucher: nil,
      total: "Rp60.000",
      totalAdjustment: 150000,
      expiredAt: 1729926810
    )
    
  }
  
  public func requestUseVoucher(
    headers: AprodhitKit.HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> VoucherEntity {
    
    VoucherEntity(
      success: false,
      code: "",
      amount: "",
      tnc: "",
      descriptions: "",
      duration: 0
    )
    
  }
  
  public func requestCreatePayment(
    headers: HeaderRequest,
    parameters: PaymentParamRequest
  ) async throws -> PaymentEntity {
    
    PaymentEntity(
      urlString: "https://google.com",
      roomKey: "192734ykdjfg3945y87y445"
    )
  }
  
  public func requestRemoveVoucher(
    headers: HeaderRequest,
    parameters: VoucherParamRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestRejectionPayment(
    headers: HeaderRequest,
    parameters: PaymentRejectionRequest
  ) async throws -> Bool {
    return true
  }
  
  public func fetchOngoingUserCases(
    headers: [String : String],
    parameters: UserCasesParamRequest
  ) async throws -> [UserCases] {
    
    return [.init()]
  }
  
  public func requestReasons(headers: HeaderRequest) async throws -> [ReasonEntity] {
    return [
      ReasonEntity(id: 1, title: "Ingin melihat advokat lain"),
      ReasonEntity(id: 2, title: "Bidang keahlian advokat tidak sesuai dengan permasalahan saya"),
      ReasonEntity(id: 3, title: "Saya ingin mengganti deskripsi masalah"),
      ReasonEntity(id: 4, title: "Biaya konsultasi kurang sesuai anggaran saya"),
      ReasonEntity(id: 5, title: "Koneksi internet saya tidak stabil"),
      ReasonEntity(id: 6, title: "Saya tidak menemukan metode pembayaran yang sesuai"),
      ReasonEntity(id: 7, title: "Lainnya")
    ]
  }
  
  public func requestCancelReason(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentCancel(
    headers: HeaderRequest,
    parameters: CancelPaymentRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestDismissRefund(
    headers: AprodhitKit.HeaderRequest,
    parameters: DismissRefundRequest
  ) async throws -> Bool {
    return true
  }
  
  public func requestPaymentMethod(headers: HeaderRequest) async throws -> [PaymentMethodEntity] {
    return []
  }
  
  public func requestEligibleVoucher(
    headers: HeaderRequest,
    parameters: EligibleVoucherParamRequests
  ) async throws -> [EligibleVoucherEntity] {
    return [
      .init(
        name: "Bronze Pertamina",
        code: "BRONZE12",
        tnc: "",
        expiredDate: Date()
      ),
      .init(
        name: "Bronze Shell",
        code: "BRONZE99",
        tnc: "",
        expiredDate: Date()
      )
    ]
  }
  
}
