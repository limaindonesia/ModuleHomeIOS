//
//  Transformable.swift
//
//
//  Created by Ilham Prabawa on 30/07/24.
//

import Foundation

protocol Transformable {
  associatedtype D
  associatedtype E
  associatedtype VM

  static func map(from data: D) -> E
  static func mapTo(_ entity: E) -> VM
}
