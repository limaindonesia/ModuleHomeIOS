//
//  PaymentRepositoryTests.swift
//
//
//  Created by Ilham Prabawa on 26/10/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit
import GnDKit

final class PaymentRepositoryTests: XCTestCase {

  var sut: PaymentRepositoryLogic!

  public func test_fetchOrderByNumber_andProcessTheExpiredTimeTo_timeRemaining() async {
    //given
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    var expiredAt: TimeInterval? = nil

    //when
    do {
      let entity = try await sut.requestOrderByNumber(
        HeaderRequest(token: ""),
        OrderNumberParamRequest(orderNumber: "")
      )

      let viewModel = OrderNumberEntity.mapTo(entity)
      let timeRemaining = viewModel.getRemainingMinutes()
      expiredAt = timeRemaining
      print("timeremainig", timeRemaining.timeString())
    } catch {
      expiredAt = nil
    }

    //then
    XCTAssertNotNil(expiredAt)
  }

}