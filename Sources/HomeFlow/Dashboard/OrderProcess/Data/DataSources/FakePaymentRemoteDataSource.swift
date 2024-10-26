//
//  FakePaymentRemoteDataSource.swift
//
//
//  Created by Ilham Prabawa on 26/10/24.
//

import Foundation
import AprodhitKit
import GnDKit

public struct FakePaymentRemoteDataSource: PaymentRemoteDataSourceLogic {

  public init() {}

  public func requestOrderByNumber(
    _ headers: [String : String],
    _ parameters: [String : Any]
  ) async throws -> OrderNumberResponseModel {

    guard let data = try? loadJSONFromFile(
      filename: "order_by_number",
      inBundle: .module
    )
    else {
      throw ErrorMessage(
        id: -7,
        title: "Failed",
        message: "File Not Found"
      )
    }

    var model: OrderNumberResponseModel

    do {
      model = try JSONDecoder().decode(OrderNumberResponseModel.self, from: data)
    } catch {
      throw ErrorMessage(
        id: -4,
        title: "Failed",
        message: "Parse Error"
      )
    }

    return model
  }

}
