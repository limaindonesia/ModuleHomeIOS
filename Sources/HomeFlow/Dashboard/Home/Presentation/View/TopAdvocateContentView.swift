//
//  TopAdvocateContentView.swift
//
//
//  Created by Ilham Prabawa on 10/10/24.
//

import SwiftUI
import AprodhitKit
import Kingfisher

public struct TopAdvocateContentView: View {

  private let items: [TopAdvocateViewModel]
  private let month: String
  private let onTapAction: () -> Void

  public init(
    items: [TopAdvocateViewModel],
    month: String,
    onTapAction: @escaping () -> Void
  ) {
    self.items = items
    self.month = month
    self.onTapAction = onTapAction
  }

  public var body: some View {
    VStack {

      HStack(alignment: .top) {
        Image("ic_medalion")
          .resizable()
          .frame(width: 51, height: 38)
          .foregroundColor(Color.white)
          .clipped(antialiased: true)
          .padding(.trailing, 4)

        VStack(alignment: .leading) {
          Text("TOP ADVOKAT dan TOP INSTANSI")
            .foregroundColor(Color.white)
            .titleStyle(size: 14)

          Text("Periode: \(month)")
            .foregroundColor(Color.primary500)
            .titleStyle(size: 14)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.primary050)
            .cornerRadius(4)

          GeometryReader { proxy in

            let frame = proxy.frame(in: .local)

            HStack(alignment: .center) {
              ZStack {
                ForEachWithIndex(items, id: \.id) { (index, item)  in
                  renderCircleImageView(index: index, item: item)
                }
              }
              .frame(maxWidth: .infinity, minHeight: 80)
              .position(x: frame.midX + 20, y: frame.midY + 50)
            }

          }
        }
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 12)

      Button(
        action: onTapAction,
        label: {
          Text("Selengkapnya")
            .foregroundColor(Color.white)
            .captionStyle(size: 12)
            .frame(maxWidth: .infinity, maxHeight: 34)
            .padding(.bottom, 12)
        }
      )

    }
    .frame(maxWidth: .infinity, maxHeight: 198)
    .background(
      RadialGradient(
        colors: [Color.gradient1, Color.gradient2],
        center: .topLeading,
        startRadius: 30,
        endRadius: 300
      )
    )
    .cornerRadius(8)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  func renderCircleImageView(
    index: Int,
    item: TopAdvocateViewModel
  ) -> some View {
    if item.name.isEmpty {
      VStack{
        Text("+10")
          .foregroundColor(Color.primary500)
          .titleStyle(size: 20)
      }
      .frame(width: 64, height: 64)
      .background(Color.white)
      .clipShape(Circle())
      .overlay(
        Circle().stroke(Color.gray100, lineWidth: 2.45)
      )
      .position(x: CGFloat(index * 38))

    } else {
      KFImage
        .url(item.getImageURL())
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(
              Color.gray100,
              lineWidth: 2.45
            )
        )
        .frame(width: 64, height: 64)
        .position(x: CGFloat(index * 38))
    }
  }

}

#Preview {
  TopAdvocateContentView(
    items: [],
    month: "",
    onTapAction: {}
  )
}
