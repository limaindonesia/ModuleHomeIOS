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
        OrderNumberParamRequest(
          orderNumber: "",
          voucherCode: ""
        )
      )

      let viewModel = OrderEntity.mapTo(entity)
      let timeRemaining = viewModel.getRemainingMinutes()
      expiredAt = timeRemaining
      
    } catch {
      expiredAt = nil
    }

    //then
    XCTAssertNotNil(expiredAt)
  }

  public func test_fetchOrderByNumber_andProcessTheExpiredTimeTo_DateTime() async {
    //given
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    var expiredAt: String? = nil

    //when
    do {
      let entity = try await sut.requestOrderByNumber(
        HeaderRequest(token: ""),
        OrderNumberParamRequest(
          orderNumber: "",
          voucherCode: ""
        )
      )

      let date = Double(entity.expiredAt).epochToDate()
      expiredAt = date.formatted(with: "dd MMMM yyyy HH:mm")

    } catch {
      expiredAt = nil
    }

    //then
    XCTAssertEqual(expiredAt, "26 October 2024 14:13")
  }
  
  public func test_fetchOrderByNumber_andDiscountShouldNil() async {
    //given
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    var discountFee: FeeEntity? = nil

    //when
    do {
      let entity = try await sut.requestOrderByNumber(
        HeaderRequest(token: ""),
        OrderNumberParamRequest(
          orderNumber: "",
          voucherCode: ""
        )
      )
      
      discountFee = entity.discountFee
      
    } catch {
      discountFee = nil
    }

    //then
    XCTAssertNil(discountFee)
  }
  
  public func test_requestPaymentMethod_andReturnSuccess() async {
   
    //given
    let headers = HeaderRequest(token: "")
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    
    //when
    let methods = try? await sut.requestPaymentMethod(headers: headers)
    
    //then
    XCTAssertNotNil(methods)
    
  }
  
  public func test_requestPaymentMethod_andShouldHaveVA() async {
   
    //given
    let headers = HeaderRequest(token: "")
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    
    //when
    let result = try? await sut.requestPaymentMethod(headers: headers)
    guard let methods = result else { return }
    let categories = methods.map { $0.category }
    
    //then
    XCTAssertTrue(categories.contains(where: { $0 == .VA }))
    
  }
  
  public func test_requestPaymentMethod_andShouldHaveEWallet() async {
   
    //given
    let headers = HeaderRequest(token: "")
    let remote = FakePaymentRemoteDataSource()
    sut = PaymentRepository(remote: remote)
    
    //when
    let result = try? await sut.requestPaymentMethod(headers: headers)
    guard let methods = result else { return }
    let categories = methods.map { $0.category }
    
    //then
    XCTAssertTrue(categories.contains(where: { $0 == .EWALLET }))
    
  }
  
}
