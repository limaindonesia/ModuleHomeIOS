//
//  MockLegalFormRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//


import Foundation
import AprodhitKit

public class MockLegalFormRepository: LegalFormRepositoryLogic {
  
  public init() {}
  
  public func fetchLegalFormDocuments(
    headers: HeaderRequest,
    parameters: UserCasesParamRequest
  ) async throws -> [LegalFormEntity] {
    
    let entities = [
      LegalFormEntity(
        type: .BOOKED,
        status: .WAITING_FOR_PAYMENT,
        title: "Perjanjian Pinjam Meminjam",
        timeRemaining: 190,
        date: "2025-03-10T10:00:00.000000Z",
        price: "Rp 140.000",
        rating: 5,
        legalFormID: "67b6a8adcfb7ef57cba5eb77",
        orderNumber: "LF-240702061",
        paymentURL: "",
        adminFee: .init(name: "Biaya Layanan", amount: "Rp30.000"),
        legalFormFee: .init(name: "Biaya Dokumen Hukum ", amount: "Rp50.000"),
        discount: .init(name: "Diskon Perqara", amount: "-Rp25.000"),
        totalAmount: "Rp25.000",
        paymentMethod: "BCA Virtual Account",
        paymentStatus: "Berhasil"
      ),
      LegalFormEntity(
        type: .COMPLETED,
        status: .REJECTED,
        title: "Perjanjian Pinjam Meminjam",
        timeRemaining: 190,
        date: "2025-03-10T10:00:00.000000Z",
        price: "Rp 140.000",
        rating: 2,
        legalFormID: "67b6a8adcfb7ef57cba5eb77",
        orderNumber: "LF-240702061",
        paymentURL: "",
        adminFee: .init(name: "Biaya Layanan", amount: "Rp30.000"),
        legalFormFee: .init(name: "Biaya Dokumen Hukum ", amount: "Rp50.000"),
        discount: .init(name: "Diskon Perqara", amount: "-Rp25.000"),
        totalAmount: "Rp25.000",
        paymentMethod: "BCA Virtual Account",
        paymentStatus: "Berhasil"
      ),
    ]
    
    return entities
    
  }
  
  public func fetchDocumentByID(
    headers: HeaderRequest,
    id: String
  ) async throws -> DocumentByIDEntity {
    
    return .init(
      id: "67b6a8adcfb7ef57cba5eb77",
      totalAmount: "Rp1.400.000",
      paymentExpiredAt: "2025-03-10T10:00:00.000000Z",
      paymentMethod: "DANA",
      isClientRated: false,
      rating: 0
      
    )
  }
  
}
