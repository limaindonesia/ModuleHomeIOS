//
//  AdvocateResponseModel.swift
//
//
//  Created by Ilham Prabawa on 23/09/24.
//

import Foundation
import AprodhitKit

public struct AdvocateResponseModel: Codable {
  var success: Bool?
  var data: [Advocate]
  var message: String?
}
