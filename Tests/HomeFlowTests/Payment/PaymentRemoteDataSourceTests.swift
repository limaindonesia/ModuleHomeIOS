//
//  PaymentRemoteDataSourceTests.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 12/03/25.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import GnDKit

final class PaymentRemoteDataSourceTests: XCTestCase {

  private var sut: PaymentRemoteDataSourceLogic!
  
  func test_fetch_orderByNumber_legalForm_shouldReturnSuccess() async {
    //given
    var response: OrderResponseModel? = nil
    let service = MockNetworkService()
    
    do {
      service.mockData = try loadJSONFromFile(filename: "order_number_legalform", inBundle: .module)
    } catch {
      print("Error", "cannot load json from file")
    }
    
    sut = PaymentRemoteDataSource(service: service)
    
    //when
    do {
      response = try await sut.requestOrderByNumber([:], [:])
    } catch {
      guard let error = error as? NetworkErrorMessage else { return }
      service.mockError = error
    }
    
    //then
    let model = try! XCTUnwrap(response)
    XCTAssertNotNil(model.data?.orderItems?.documentFee)
  }

}
