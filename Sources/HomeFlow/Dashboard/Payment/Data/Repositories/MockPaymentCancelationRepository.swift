//
//  MockPaymentCancelationRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 28/11/24.
//

import Foundation
import AprodhitKit
import GnDKit

public class MockPaymentCancelationRepository: PaymentCancelationRepositoryLogic {
  
  public init() {}
  
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
  
 
}
