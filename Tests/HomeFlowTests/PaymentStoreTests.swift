//
//  PaymentStoreTests.swift
//
//
//  Created by Ilham Prabawa on 27/10/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import GnDKit

final class PaymentStoreTests: XCTestCase {

  var sut: PaymentStore!

  private func makeSUT() -> PaymentStore {
    let remote = FakePaymentRemoteDataSource()
    let paymentRepository = PaymentRepository(remote: remote)
    
    return PaymentStore(
      userSessionDataSource: MockUserSessionDataSource(),
      lawyerInfoViewModel: .init(),
      orderProcessRepository: MockOrderProcessRepository(),
      paymentRepository: paymentRepository,
      treatmentRepository: MockTreatmentRepository(),
      ongoingRepository: MockPaymentRepository(),
      cancelationRepository: MockPaymentCancelationRepository(),
      ongoingNavigator: MockNavigator(),
      paymentNavigator: MockNavigator(),
      dashboardResponder: MockNavigator()
    )
  }
  
  public func test_getLawyerInfo_andGet_theOrderNumber() {

  }
  
  public func test_requestPaymentMethods_andReturnTotalOfData() async {
    //given
    sut = makeSUT()
    
    //when
    await sut.requestPaymentMethods()
    
    //then
    XCTAssertEqual(sut.payments.count, 6)
  }
  
  public func test_requestPaymentMethods_andReturnVAsOnly() async {
    //given
    var vaItems: [PaymentMethodViewModel] = []
    sut = makeSUT()
    
    //when
    await sut.requestPaymentMethods()
    vaItems = sut.payments.filter { $0.category == .VA }
    
    //then
    XCTAssertEqual(vaItems.count, 4)
  }

  public func test_requestPaymentMethods_andReturnEWalletsOnly() async {
    //given
    var walletItems: [PaymentMethodViewModel] = []
    sut = makeSUT()
    
    //when
    await sut.requestPaymentMethods()
    walletItems = sut.payments.filter { $0.category == .EWALLET }
    
    //then
    XCTAssertEqual(walletItems.count, 2)
  }

}
