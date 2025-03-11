//
//  LegalDocumentRepositoryTests.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/03/25.
//

import XCTest
import GnDKit
import AprodhitKit
@testable import HomeFlow

final class LegalDocumentRepositoryTests: XCTestCase {
  
  var sut: LegalFormRepositoryLogic!
  
  func test_fetchLegalDocument_shouldReturnSuccess() async {
    
    //given
    var entities: [LegalFormEntity] = []
    let service = MockNetworkService()
    service.mockData = """
      {
          "success": true,
          "data": {
              "data": [
                  {
                      "id": "67c52c3e238b9ce172f62226",
                      "document_id": 6,
                      "order_no": "LF-250227006",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "ON_PROGRESS",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T14:13:36.972Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-03-05T14:13:36.000000Z"
                      }
                  },
                  {
                      "id": "67c52c3e238b9ce172f62225",
                      "document_id": 5,
                      "order_no": "LF-250227005",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "ON_PROGRESS",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T12:26:06.410Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-02-28T12:26:06.000000Z"
                      }
                  },
                  {
                      "id": "67c52c3e238b9ce172f62224",
                      "document_id": 4,
                      "order_no": "LF-250227004",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "BOOKED",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T11:35:53.645Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-02-28T11:35:53.000000Z"
                      }
                  },
                  {
                      "id": "67c52c3e238b9ce172f62223",
                      "document_id": 3,
                      "order_no": "LF-250227003",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "BOOKED",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T11:25:03.507Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-02-28T11:25:03.000000Z"
                      }
                  },
                  {
                      "id": "67c52c3e238b9ce172f62222",
                      "document_id": 2,
                      "order_no": "LF-250227002",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "BOOKED",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T07:47:23.098Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-02-28T07:47:23.000000Z"
                      }
                  },
                  {
                      "id": "67c52c3e238b9ce172f62221",
                      "document_id": 1,
                      "order_no": "LF-250227001",
                      "client_id": 3180,
                      "legal_form_id": "67b6a8adcfb7ef57cba5eb77",
                      "status": "BOOKED",
                      "is_client_rated": false,
                      "document_rating": 0,
                      "generated_at": "",
                      "created_at": "2025-02-27T07:14:29.286Z",
                      "legal_form": {
                          "id": "67b6a8adcfb7ef57cba5eb77",
                          "category_id": "Employment",
                          "name": "Employment Agreement",
                          "price": "Rp75.000",
                          "final_price": "Rp75.000",
                          "description": "Standard employment agreement for full-time employees",
                          "picture_url": "https://example.com/images/employment-agreement.jpg",
                          "category": "Employment",
                          "rating": "4",
                          "total_created": 300
                      },
                      "payment": {
                          "payment_url": "",
                          "order_items": {
                              "admin_fee": {
                                  "name": "Biaya Layanan",
                                  "amount": "Rp10.000"
                              },
                              "legal_form_fee": {
                                  "name": "Biaya Dokumen Hukum",
                                  "amount": "Rp75.000"
                              },
                              "discount": {}
                          },
                          "total_amount": "Rp85.000",
                          "payment_method": "",
                          "payment_status": "",
                          "payment_expired_at": "2025-02-28T07:14:29.000000Z"
                      }
                  }
              ],
              "pagination": {
                  "total": 6,
                  "count": 6,
                  "per_page": 10,
                  "current_page": 1,
                  "last_page": 1,
                  "links": {
                      "next": null
                  }
              }
          },
          "message": "User Documents berhasil didapat."
      }
    """.data(using: .utf8)!
    
    let remote = LegalFormRemoteDataSourceImpl(service: service)
    sut = LegalFormRepositoryImpl(remote: remote)
    
    //when
    do {
      entities = try await sut.fetchLegalFormDocuments(
        headers: HeaderRequest(token: ""),
        parameters: UserCasesParamRequest(type: .ONGOING)
      )
    } catch {
      
    }
    
    //then
    XCTAssertEqual(entities.count, 6)
    XCTAssertEqual(entities[0].type, .ON_PROGRESS)
    XCTAssertEqual(entities[3].type, .BOOKED)
    XCTAssertEqual(entities[3].title, "Employment Agreement")
    
  }
  
}
