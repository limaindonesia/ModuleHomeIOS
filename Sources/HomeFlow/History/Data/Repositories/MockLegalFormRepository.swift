//
//  MockLegalFormRepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/02/25.
//


import Foundation

public class MockLegalFormRepository: LegalFormRepositoryLogic {
  
  public init() {}
  
  public func fetchLegalFormDocuments() async throws -> [LegalFormDocumentEntity] {
    return [
//      LegalFormDocumentEntity(
//        type: "ACTIVE",
//        status: "WAITING_FOR_PAYMENT",
//        title: "Perjanjian Pinjam Meminjam (Utang Piutang)",
//        timeRemaining: 0.0,
//        date: "",
//        price: "Rp10.000"
//      ),
//      LegalFormDocumentEntity(
//        type: "ACTIVE",
//        status: "ON_PROCESS",
//        title: "Surat Pernyataan Ahli Waris",
//        timeRemaining: 0.0,
//        date: "",
//        price: "Rp100.000"
//      ),
//      LegalFormDocumentEntity(
//        type: "HISTORY",
//        status: "DONE",
//        title: "Surat Pernyataan Ahli Waris",
//        timeRemaining: 0.0,
//        date: "",
//        price: "Rp100.000"
//      )
    ]
  }
  
}
