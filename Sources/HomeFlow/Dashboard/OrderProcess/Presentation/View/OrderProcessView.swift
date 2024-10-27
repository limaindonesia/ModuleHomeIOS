//
//  OrderProcessView.swift
//
//
//  Created by Ilham Prabawa on 22/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct OrderProcessView: View {

  @ObservedObject var store: OrderProcessStore

  private init() {
    self.store = .init()
  }

  public init(store: OrderProcessStore) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      VStack {
        ScrollView {
          VStack(spacing: 12) {
            showLawyerInfo()
              .padding(.horizontal, 16)

            issueView {
              store.showChangeCategory()
            }
            .padding(.horizontal, 16)

            requestProbonoView()
              .padding(.horizontal, 16)
          }
          .padding(.top, 16)
        }

        Spacer()

        PaymentBottomView(
          title: "Biaya",
          price: store.isProbonoActive
          ? store.getPriceProbonoOnly()
          : store.getPrice(),
          buttonText: "Ke Pembayaran",
          isButtonActive: store.isTextValid,
          onTap: {
            store.processNavigation()
          }
        )
        .padding(.horizontal, 16)
      }

      BottomSheetView(isPresented: $store.isPresentBottomSheet) {
        OrderInfoBottomSheetView(
          price: store.isProbonoActive
          ? store.getPriceProbonoOnly()
          : store.getPrice()
        ) {
          store.navigateToPayment()
        }
      }

      BottomSheetView(isPresented: $store.isPresentChangeCategoryIssue) {
        ChangeCategoryIssueView(
          issues: store.issues,
          selectedID: store.getSelectedCategoryID()
        ) { category in
          store.setSelected(category)
        } onTap: { _ in
          store.dismissChangeCategory()
        }
      }

    }
    .ignoresSafeArea(.keyboard)
  }

  @ViewBuilder
  func showLawyerInfo() -> some View {
    if store.isProbono() {
      LawyerInfoProbonoView(
        imageURL: store.lawyerInfoViewModel.imageURL,
        name: store.lawyerInfoViewModel.name,
        agency: store.lawyerInfoViewModel.agency,
        price: store.getPriceProbonoOnly(),
        originalPrice: store.lawyerInfoViewModel.originalPrice,
        isDiscount: store.lawyerInfoViewModel.isDiscount,
        isProbono: store.lawyerInfoViewModel.isProbono,
        timeStr: store.timeConsultation,
        toggleActive: $store.isProbonoActive
      )
    } else {
      lawyerInfoView(
        imageURL: store.lawyerInfoViewModel.imageURL,
        name: store.lawyerInfoViewModel.name,
        agency: store.lawyerInfoViewModel.agency,
        price: store.lawyerInfoViewModel.price,
        originalPrice: store.lawyerInfoViewModel.originalPrice,
        isDiscount: store.lawyerInfoViewModel.isDiscount,
        isProbono: store.lawyerInfoViewModel.isProbono,
        timeStr: store.timeConsultation
      )
    }
  }

  @ViewBuilder
  func lawyerInfoView(
    imageURL: URL?,
    name: String,
    agency: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Bool,
    timeStr: String
  ) -> some View {
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
      .padding(.all, 12)

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
    }
    .frame(maxWidth: .infinity, maxHeight: 130)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

  @ViewBuilder
  func issueView(onTap: @escaping () -> Void) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Tuliskan Deskripsi Masalah")
        .foregroundColor(.titleColor)
        .titleLexend(size: 14)
        .padding(.horizontal, 12)
        .padding(.top, 12)

      Text("Mohon ceritakan masalah yang akan Anda konsultasikan")
        .bodyLexend(size: 12)
        .padding(.horizontal, 12)
        .padding(.trailing, 50)

      VStack {
        TextView(
          text: $store.issueText,
          textStyle: .lexendFont(style: .caption(size: 12)),
          textColor: .darkTextColor,
          backgroundColor: .gray050
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              store.isTextValid ? Color.gray500 : Color.red,
              lineWidth: 2
            )
        )
      }
      .frame(maxWidth: .infinity, idealHeight: 88)
      .background(Color.gray050)
      .cornerRadius(6)
      .padding(.horizontal, 12)

      Text("*Minimal 10 Karakter")
        .foregroundColor(store.isTextValid ? Color.gray500 : Color.red)
        .bodyLexend(size: 12)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)

      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray200)
        .padding(.horizontal, 12)

      Text("Kategori Hukum")
        .titleLexend(size: 14)
        .padding(.horizontal, 12)
        .padding(.top, 16)

      HStack {
        Text(store.getIssueName())
          .foregroundColor(Color.primaryInfo600)
          .bodyLexend(size: 14)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(Color.primaryInfo100)
          .cornerRadius(14)

        Spacer()

        Button{
          onTap()
        } label: {
          Text("Ubah")
            .foregroundColor(Color.buttonActiveColor)
            .titleLexend(size: 14)
        }
      }
      .padding(.horizontal, 12)

      HStack(
        alignment: .center,
        spacing: 8
      ) {
        Image("ic_warning", bundle: .module)
          .resizable()
          .frame(width: 24, height: 24)

        Text("Mohon pastikan kategori hukum yang Anda pilih sudah sesuai")
          .foregroundColor(.warning900)
          .captionLexend(size: 12)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(red: 0.99, green: 0.96, blue: 0.9))
      .cornerRadius(8)
      .padding(.horizontal, 12)
      .padding(.bottom, 12)
    }
    .frame(maxWidth: .infinity, minHeight: 180)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

  @ViewBuilder
  func requestProbonoView() -> some View {
    VStack(spacing: 0) {
      HStack {
        Text("Ajukan layanan Pro bono?")
          .captionLexend(size: 12)

        Button {

        } label: {
          Text("Lihat detail")
            .foregroundColor(Color.buttonActiveColor)
            .bodyLexend(size: 12)
        }
      }

    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, minHeight: 32)
    .background(.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

}

#Preview {
  OrderProcessView(store: .init())
}
