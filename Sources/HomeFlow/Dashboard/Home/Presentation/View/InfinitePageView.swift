//
//  InfinitePageView.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 20/02/25.
//

import SwiftUI

struct InfinitePageView<C, T>: View where C: View, T: Hashable {
  
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @Binding var selection: T

    let before: (T) -> T
    let after: (T) -> T

    @ViewBuilder let view: (T) -> C

    @State private var currentTab: Int = 0

    var body: some View {
        let previousIndex = before(selection)
        let nextIndex = after(selection)
        TabView(selection: $currentTab) {
            view(previousIndex)
                .tag(-1)

            view(selection)
                .onDisappear() {
                    if currentTab != 0 {
                        selection = currentTab < 0 ? previousIndex : nextIndex
                        currentTab = 0
                    }
                }
                .tag(0)
                .onReceive(timer, perform: { _ in
                  withAnimation {
                    currentTab = currentTab + 1
                  }
                })

            view(nextIndex)
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .disabled(currentTab != 0)
    }
}

#Preview {
  let systemColors: [Color] = [
          .red, .orange, .yellow, .green,
          .mint, .teal, .cyan, .blue,
          .indigo, .purple, .pink, .brown
      ]
  @State var colorIndex = 0
  InfinitePageView(
              selection: $colorIndex,
              before: { _ in 0 },
              after: { _ in 0 },
              view: { index in
                  systemColors[index]
                      .overlay(
                          Text("\(index)     \(index)")
                              .colorInvert()
                      )
                      .font(.system(size: 100, weight: .heavy))
              }
          )

}
