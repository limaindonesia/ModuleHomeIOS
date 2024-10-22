////
////  PaymentTests.swift
////
////
////  Created by Ilham Prabawa on 03/10/24.
////
//
//import XCTest
//
//final class PaymentTests: XCTestCase {
//
//  func test_fetch_userOderDetail() {
//
//    let mock = MockNetworkService()
//    mock.mockData =
//  }
//
//}
//
//func getUserOrderDetail(
//  orderID: String,
//  completion: @escaping(Result<UserOrderDetailGetResp, Err>) -> ()
//) {
//  self.client.combineGetWithToken(
//    url: "\(PaymentServiceUrl.orderDetail)\(orderID)",
//    responseType: UserOrderDetailGetResp.self
//  )
//  .receive(on: DispatchQueue.main)
//  .sink { result in
//    switch result {
//    case .failure(let Err):
//      completion(.failure(Err))
//      break
//    case .finished:
//      break
//    }
//  } receiveValue: { data in
//    completion(.success(data))
//  }.store(in: &subscriptions)
//}
