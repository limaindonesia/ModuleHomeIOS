//
//  ListAdvocateView.swift
//
//
//  Created by Ilham Prabawa on 15/09/24.
//

import SwiftUI

struct ListAdvocateView: View {
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(0..<100) { item in
          Text("hello advocate \(item)")
        }
      }
    }
  }
}

#Preview {
  ListAdvocateView()
}
