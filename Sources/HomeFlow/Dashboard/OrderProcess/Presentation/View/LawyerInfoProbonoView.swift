//
//  LawyerInfoProbonoView.swift
//
//
//  Created by Ilham Prabawa on 27/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct LawyerInfoProbonoView: View {

  private let imageURL: URL?
  private let name: String
  private let agency: String
  private let price: String
  private let originalPrice: String
  private let isDiscount: Bool
  private let timeStr: String
  @Binding private var isProbono: Bool
  @Binding private var toggleActive: Bool

  init(
    imageURL: URL?,
    name: String,
    agency: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Binding<Bool>,
    timeStr: String,
    toggleActive: Binding<Bool>
  ) {
    self.imageURL = imageURL
    self.name = name
    self.agency = agency
    self.price = price
    self.originalPrice = originalPrice
    self.isDiscount = isDiscount
    self._isProbono = isProbono
    self.timeStr = timeStr
    self._toggleActive = toggleActive
  }

  var body: some View {
    VStack {
      HStack(spacing: 12) {
        CircleAvatarImageView(
          imageURL,
          width: 48,
          height: 48
        )

        VStack(alignment: .leading, spacing: 4) {
          Text(name)
            .titleLexend(size: 14)

          Text(agency)
            .foregroundColor(.darkGray400)
            .bodyLexend(size: 14)
        }

        Spacer()

        Image("ic_down_arrow", bundle: .module)

      }
      .padding(.horizontal, 12)
      .padding(.top, 12)

      HStack {
        if isProbono {
          probonoPriceView()
        } else {
          regularPriceView()
        }

        Circle()
          .fill(Color.darkGray300)
          .frame(width: 6, height: 6)

        HStack(spacing: 2) {
          Image("ic_timer", bundle: .module)

          Text(timeStr)
            .foregroundColor(Color.gray600)
            .bodyLexend(size: 12)
        }

        Spacer()
      }
      .padding(.all, 12)

      Divider()
        .frame(height: 1)
        .foregroundColor(Color.black)
        .padding(.horizontal, 12)

      HStack {
        ToggleView(
          isActive: $toggleActive,
          tapAction: {
            isProbono = toggleActive
          }
        )

        Text("Gunakan Kuota Pro Bono")
          .foregroundColor(Color.darkTextColor)
          .captionLexend(size: 12)

        Spacer()

        Text("Kuota: 3")
          .captionLexend(size: 12)
      }
      .padding(.all, 12)

    }
    .frame(maxWidth: .infinity, minHeight: 160)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

  @ViewBuilder
  func probonoPriceView() -> some View {
    Text("Gratis")
      .foregroundColor(Color.buttonActiveColor)
      .titleLexend(size: 14)
  }

  @ViewBuilder
  func regularPriceView() -> some View {
    HStack {
      Text(price)
        .foregroundColor(Color.buttonActiveColor)
        .titleLexend(size: 14)

      HStack(spacing: 4) {
        StrikethroughText(
          text: originalPrice,
          color: .darkTextColor,
          thickness: 1
        )

        if isDiscount {
          DiscountView()
        }
      }
    }
  }
}

#Preview {
  LawyerInfoProbonoView(
    imageURL: nil,
    name: "Terry Hasibuan S.H",
    agency: "",
    price: "Gratis",
    originalPrice: "",
    isDiscount: false,
    isProbono: .constant(true),
    timeStr: "30 Menit",
    toggleActive: .constant(true)
  )
  .padding(.horizontal, 16)
}
