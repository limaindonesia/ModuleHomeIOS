//
//  ConsultationHistoryRepositoryTests.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 27/02/25.
//

import XCTest
import AprodhitKit
import GnDKit
@testable import HomeFlow

final class ConsultationHistoryRepositoryTests: XCTestCase {
  
  var sut: ConsultationHistoryRepositoryLogic!
  
  func test_fetchCategories_shouldCount_One() async throws {
    //given
    let service = MockNetworkService()
    let remote = ConsultationHistoryRemoteDataSourceImpl(service: service)
    
    service.mockData = JSONResponse.history
    
    sut = ConsultationHistoryRepositoryImpl(remoteDataSource: remote)
    
    //when
    let consultations = try await sut.getConsultations(
      headers: HeaderRequest(token: ""),
      parameters: UserCasesParamRequest(type: .HISTORY)
    )
    
    //then
    XCTAssertEqual(consultations.count, 1)
  }
  
  func test_fetchCategories_shouldReturnError() async throws {
    //given
    let service = MockNetworkService()
    var resultError: ErrorMessage = .init(title: "", message: "")
    let remote = ConsultationHistoryRemoteDataSourceImpl(service: service)
    
    service.mockError = NetworkErrorMessage(code: -898, description: "gagal maning")
    
    sut = ConsultationHistoryRepositoryImpl(remoteDataSource: remote)
    
    //when
    do {
      _ = try await sut.getConsultations(
        headers: HeaderRequest(token: ""),
        parameters: UserCasesParamRequest(type: .ONGOING)
      )
    }
    catch {
      resultError = error as! ErrorMessage
    }
    
    //then
    XCTAssertEqual(resultError.message, "gagal maning")
    XCTAssertEqual(resultError.id, -898)
  }
  
  func test_fetchCategories_shouldReturn_HistoryType() async throws {
    //given
    let service = MockNetworkService()
    let remote = ConsultationHistoryRemoteDataSourceImpl(service: service)
    
    service.mockData = JSONResponse.history
    
    sut = ConsultationHistoryRepositoryImpl(remoteDataSource: remote)
    
    //when
    let consultations = try await sut.getConsultations(
      headers: HeaderRequest(token: ""),
      parameters: UserCasesParamRequest(type: .HISTORY)
    )
    
    //then
    XCTAssertEqual(consultations.first?.type, .HISTORY)
  }
  
  func test_fetchCategories_shouldReturn_IncomingType() async throws {
    //given
    let service = MockNetworkService()
    let remote = ConsultationHistoryRemoteDataSourceImpl(service: service)
    
    service.mockData = JSONResponse.incoming
    
    sut = ConsultationHistoryRepositoryImpl(remoteDataSource: remote)
    
    //when
    let consultations = try await sut.getConsultations(
      headers: HeaderRequest(token: ""),
      parameters: UserCasesParamRequest(type: .ONGOING)
    )
    
    //then
    XCTAssertEqual(consultations.first?.type, .INCOMING)
  }

}

enum JSONResponse {
  public static let history = """
          {
            "success": true,
            "data": {
              "data": [
                {
                  "id": 407,
                  "skill": {
                    "id": 1,
                    "name": "Pidana"
                  },
                  "description": "mau coba",
                  "lawyer_attendance": "",
                  "client_attendance": "",
                  "lawyer_approved_at": "",
                  "stop_time": "",
                  "room_key": "eyJpdiI6IlN4YUFmRVBKMjZQRmZoL3MrRXdsY2c9PSIsInZhbHVlIjoiSEtEemJycCtrUEY1My9COGY3VmN4b0wreEVDcjRtMkNKTC81QmZHVGRUZUxQRWttWmxURjRQbXpoVnpPTnVCZ0I2VUxEd3Rnc1F1bDFZNFMwdGhZTnhuOUJKWUJjRFZHNVF3YmptWVRDMXo2czQ2NWdrbkVJYmJpTFZtTWlpeXllTDQyN3ArL1ZFTzBvSW1pbFg5U1hBPT0iLCJtYWMiOiI2MDg0ZDllNGU3M2Y2YjNhNjQ1MDViNDBjMWZiZDRmNDZiYTc5ZjFiODM2OGIwODJmOTcxNjNjYjkwMzM3MzBmIiwidGFnIjoiIn0=",
                  "status": "REJECTED",
                  "summary": {},
                  "booking": {
                    "id": 407,
                    "parent_id": 0,
                    "consultation_id": 407,
                    "bookingable_id": 194,
                    "bookingable_type": "AvailabilityInstant",
                    "booking_date": "2023-07-27",
                    "booking_time": "08:05:00",
                    "duration": 30,
                    "status": 0,
                    "created_at": "2023-07-27T08:05:19.000000Z",
                    "updated_at": "2023-07-27T08:05:19.000000Z"
                  },
                  "total_price": 0,
                  "last_call": "2023-07-27T08:05:21.000000Z",
                  "client": {
                    "id": 1,
                    "name": "Daniel Sahuleka",
                    "photo_url": "",
                    "birth_date": "2023-02-15",
                    "gender": "MALE",
                    "address": {
                      "address": "asdasd",
                      "city_id": 1102,
                      "city_name": "ACEH SINGKIL",
                      "postal_code_id": 0,
                      "status": 1
                    }
                  },
                  "lawyer": {
                    "id": 1,
                    "name": "ini dari postman",
                    "price": 10000,
                    "photo_url": "",
                    "gender": "MALE",
                    "city": {
                      "id": 1107,
                      "name": "ACEH BARAT"
                    },
                    "year_exp": 1,
                    "avg_rating": 5,
                    "slug": "lawyer-perqara",
                    "is_online": true,
                    "is_probono": true,
                    "agency_name": "PBN Peradi",
                    "agency_province": {
                      "id": 11,
                      "name": "ACEH"
                    },
                    "agency_city": {
                      "id": 1101,
                      "name": "SIMEULUE"
                    },
                    "description": "Saya lawyer",
                    "affidavit_url": "",
                    "ktp_url": "",
                    "address": "testt",
                    "educations": [
                      {
                        "institution_id": 2,
                        "institution_name": "Universitas Gajah Mada",
                        "degree": "S2"
                      },
                      {
                        "institution_id": 2,
                        "institution_name": "Universitas Gajah Mada",
                        "degree": "S1"
                      }
                    ],
                    "skills": [
                      {
                        "id": 1,
                        "name": "Pidana"
                      },
                      {
                        "id": 2,
                        "name": "Perdata"
                      }
                    ],
                    "skill_ids": [
                      1,
                      2
                    ]
                  },
                  "room_expired_at": "",
                  "waiting_expired_at": "2023-07-27T08:06:21.000000Z"
                }
              ],
              "links": {
                "first": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=1",
                "last": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=29",
                "prev": "",
                "next": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2"
              },
              "meta": {
                "current_page": 1,
                "from": 1,
                "last_page": 29,
                "links": [
                  {
                    "url": "",
                    "label": "&laquo; Previous",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=1",
                    "label": "1",
                    "active": true
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2",
                    "label": "2",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=3",
                    "label": "3",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=4",
                    "label": "4",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=5",
                    "label": "5",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=6",
                    "label": "6",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=7",
                    "label": "7",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=8",
                    "label": "8",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=9",
                    "label": "9",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=10",
                    "label": "10",
                    "active": false
                  },
                  {
                    "url": "",
                    "label": "...",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=28",
                    "label": "28",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=29",
                    "label": "29",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2",
                    "label": "Next &raquo;",
                    "active": false
                  }
                ],
                "path": "http://localhost:8080/api/consultations/user-cases",
                "per_page": 10,
                "to": 10,
                "total": 283
              }
            },
            "message": "models/consultations.plural retrieved successfully."
          }
""".data(using: .utf8)!
  
  static let incoming = """
          {
            "success": true,
            "data": {
              "data": [
                {
                  "id": 407,
                  "skill": {
                    "id": 1,
                    "name": "Pidana"
                  },
                  "description": "mau coba",
                  "lawyer_attendance": "",
                  "client_attendance": "",
                  "lawyer_approved_at": "",
                  "stop_time": "",
                  "room_key": "eyJpdiI6IlN4YUFmRVBKMjZQRmZoL3MrRXdsY2c9PSIsInZhbHVlIjoiSEtEemJycCtrUEY1My9COGY3VmN4b0wreEVDcjRtMkNKTC81QmZHVGRUZUxQRWttWmxURjRQbXpoVnpPTnVCZ0I2VUxEd3Rnc1F1bDFZNFMwdGhZTnhuOUJKWUJjRFZHNVF3YmptWVRDMXo2czQ2NWdrbkVJYmJpTFZtTWlpeXllTDQyN3ArL1ZFTzBvSW1pbFg5U1hBPT0iLCJtYWMiOiI2MDg0ZDllNGU3M2Y2YjNhNjQ1MDViNDBjMWZiZDRmNDZiYTc5ZjFiODM2OGIwODJmOTcxNjNjYjkwMzM3MzBmIiwidGFnIjoiIn0=",
                  "status": "WAITING_FOR_PAYMENT",
                  "summary": {},
                  "booking": {
                    "id": 407,
                    "parent_id": 0,
                    "consultation_id": 407,
                    "bookingable_id": 194,
                    "bookingable_type": "AvailabilityInstant",
                    "booking_date": "2023-07-27",
                    "booking_time": "08:05:00",
                    "duration": 30,
                    "status": 0,
                    "created_at": "2023-07-27T08:05:19.000000Z",
                    "updated_at": "2023-07-27T08:05:19.000000Z"
                  },
                  "total_price": 0,
                  "last_call": "2023-07-27T08:05:21.000000Z",
                  "client": {
                    "id": 1,
                    "name": "Daniel Sahuleka",
                    "photo_url": "",
                    "birth_date": "2023-02-15",
                    "gender": "MALE",
                    "address": {
                      "address": "asdasd",
                      "city_id": 1102,
                      "city_name": "ACEH SINGKIL",
                      "postal_code_id": 0,
                      "status": 1
                    }
                  },
                  "lawyer": {
                    "id": 1,
                    "name": "ini dari postman",
                    "price": 10000,
                    "photo_url": "",
                    "gender": "MALE",
                    "city": {
                      "id": 1107,
                      "name": "ACEH BARAT"
                    },
                    "year_exp": 1,
                    "avg_rating": 5,
                    "slug": "lawyer-perqara",
                    "is_online": true,
                    "is_probono": true,
                    "agency_name": "PBN Peradi",
                    "agency_province": {
                      "id": 11,
                      "name": "ACEH"
                    },
                    "agency_city": {
                      "id": 1101,
                      "name": "SIMEULUE"
                    },
                    "description": "Saya lawyer",
                    "affidavit_url": "",
                    "ktp_url": "",
                    "address": "testt",
                    "educations": [
                      {
                        "institution_id": 2,
                        "institution_name": "Universitas Gajah Mada",
                        "degree": "S2"
                      },
                      {
                        "institution_id": 2,
                        "institution_name": "Universitas Gajah Mada",
                        "degree": "S1"
                      }
                    ],
                    "skills": [
                      {
                        "id": 1,
                        "name": "Pidana"
                      },
                      {
                        "id": 2,
                        "name": "Perdata"
                      }
                    ],
                    "skill_ids": [
                      1,
                      2
                    ]
                  },
                  "room_expired_at": "",
                  "waiting_expired_at": "2023-07-27T08:06:21.000000Z"
                }
              ],
              "links": {
                "first": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=1",
                "last": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=29",
                "prev": "",
                "next": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2"
              },
              "meta": {
                "current_page": 1,
                "from": 1,
                "last_page": 29,
                "links": [
                  {
                    "url": "",
                    "label": "&laquo; Previous",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=1",
                    "label": "1",
                    "active": true
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2",
                    "label": "2",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=3",
                    "label": "3",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=4",
                    "label": "4",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=5",
                    "label": "5",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=6",
                    "label": "6",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=7",
                    "label": "7",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=8",
                    "label": "8",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=9",
                    "label": "9",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=10",
                    "label": "10",
                    "active": false
                  },
                  {
                    "url": "",
                    "label": "...",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=28",
                    "label": "28",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=29",
                    "label": "29",
                    "active": false
                  },
                  {
                    "url": "http://localhost:8080/api/consultations/user-cases?type=history&paginate=true&page=2",
                    "label": "Next &raquo;",
                    "active": false
                  }
                ],
                "path": "http://localhost:8080/api/consultations/user-cases",
                "per_page": 10,
                "to": 10,
                "total": 283
              }
            },
            "message": "models/consultations.plural retrieved successfully."
          }
""".data(using: .utf8)!
}
