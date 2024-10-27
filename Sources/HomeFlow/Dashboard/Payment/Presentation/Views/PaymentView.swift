//
//  PaymentView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct PaymentView: View {

  @ObservedObject var store: PaymentStore

  init(store: PaymentStore) {
    self.store = store
  }

  var body: some View {
    ZStack {
      VStack {
        ScrollView(showsIndicators: false) {
          VStack(spacing: 12) {
            lawyerInfoView(
              orderID: store.getOrderNumber(),
              timeRemaining: store.getTimeRemaining(),
              imageURL: store.getAvatarImage(),
              name: store.getLawyersName(),
              agency: store.getAgency(),
              consultationTime: store.timeConsultation
            )

            if !store.isProbono() {
              voucherCode {
                store.showVoucherBottomSheet()
              }

              paymentOptions()
            }

            paymentDetail()

          }
          .background(Color.gray050)
          .padding(.top, 8)
          .padding(.horizontal, 16)
          .padding(.bottom, 16)
        }

        PaymentBottomView(
          title: "Total Pembayaran",
          price: store.getTotalAmount(),
          buttonText: "Bayar",
          onTap: {

          }
        )
        .padding(.horizontal, 16)
      }

      BottomSheetView(isPresented: $store.isPresentVoucherBottomSheet) {
        VoucherBottomSheetView { voucher in

        }
      }
    }
  }

  @ViewBuilder
  func lawyerInfoView(
    orderID: String,
    timeRemaining: String,
    imageURL: URL?,
    name: String,
    agency: String,
    consultationTime: String
  ) -> some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("Order ID: \(orderID)")
            .foregroundColor(Color.warning900)
            .titleLexend(size: 12)

          Text("Mohon segera lakukan pembayaran")
            .foregroundColor(Color.warning900)
            .captionLexend(size: 12)
        }

        Spacer()

        HStack(spacing: 2) {
          Image("ic_timer", bundle: .module)
            .renderingMode(.template)
            .foregroundColor(Color.white)

          Text(timeRemaining)
            .foregroundColor(Color.white)
            .titleLexend(size: 12)
        }
        .padding(.all, 4)
        .background(Color.warning500)
        .cornerRadius(5)
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .frame(maxWidth: .infinity, minHeight: 40)
      .background(Color.warning050)
      .cornerRadius(8)
      .padding(.horizontal, 12)
      .padding(.top, 12)

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

      }
      .padding(.all, 12)

      HStack {
        Text("Detail")
          .foregroundColor(.darkTextColor)
          .titleLexend(size: 12)

        Spacer()

        Image("ic_down_arrow", bundle: .module)
      }
      .padding(.horizontal, 7)
      .padding(.vertical, 13)
      .frame(maxWidth: .infinity, minHeight: 40)
      .background(Color.gray050)
      .cornerRadius(8)
      .padding(.horizontal, 12)

      HStack(spacing: 8) {
        Text("Durasi konsultasi:")
          .bodyLexend(size: 12)

        HStack(spacing: 2) {

          Image("ic_timer", bundle: .module)
            .renderingMode(.template)
            .foregroundColor(Color.primaryInfo600)

          Text(consultationTime)
            .foregroundColor(Color.primaryInfo600)
            .titleLexend(size: 12)
        }

        Spacer()
      }
      .padding(.all, 12)
    }
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

  @ViewBuilder
  func voucherCode(onTap: @escaping () -> Void) -> some View {
    VStack(alignment: .leading) {
      Text("Kode Promo dan Voucher")
        .titleLexend(size: 16)

      HStack(spacing: 10) {
        Image("ticket_discount", bundle: .module)

        Text("Pilih atau tulis kode")
          .foregroundColor(Color.gray500)
          .titleLexend(size: 14)

        Spacer()

        Image("ic_chevron", bundle: .module)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.primary050)
      .cornerRadius(8)
    }
    .padding(12)
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .background(.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 5)
    .shadow(color: Color.gray050, radius: 5, x: 0, y: 6)
    .onTapGesture {
      onTap()
    }
  }

  @ViewBuilder
  func paymentOptions() -> some View {
    VStack(alignment: .leading) {
      Text("Metode Pembayaran")
        .foregroundColor(Color.darkTextColor)
        .titleLexend(size: 14)

      HStack {
        HStack {
          Image("ic_payment_shopee", bundle: .module)

          Divider()
            .frame(width: 2, height: 24)

          Image("ic_qrcode", bundle: .module)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .overlay{
          RoundedRectangle(cornerRadius: 4)
            .stroke(Color.gray100)
        }

        Image("ic_payment_ovo", bundle: .module)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .overlay{
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.gray100)
          }

        Image("ic_payment_dana", bundle: .module)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .overlay{
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.gray100)
          }
      }
      .frame(height: 40)

      HStack {
        Text("Anda akan diarahkan ke")
          .foregroundColor(Color.darkGray400)
          .captionLexend(size: 12)

        Image("ic_xendit", bundle: .module)
      }

      VStack(spacing: 8) {
        Text("Mohon perhatikan batas waktu pembayaran!")
          .captionLexend(size: 10)

        Text(store.getExpiredDate())
          .titleLexend(size: 14)
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .frame(maxWidth: .infinity, maxHeight: 344)
      .background(Color.gray050)
      .cornerRadius(8)

    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

  @ViewBuilder
  func paymentDetail() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Rincian pembayaran")
        .titleLexend(size: 14)

      ForEach(store.getPaymentDetails()) { fee in
        FeeRowView(
          name: fee.name,
          amount: fee.amount,
          showInfo: fee.showInfo,
          onTap: {
            GLogger(
              .info,
              layer: "Presentation",
              message: "did tap info"
            )
          }
        )
      }

      Divider()
        .frame(height: 1)

      HStack {
        Text("Total Pembayaran")
          .titleLexend(size: 16)

        Spacer()

        Text(store.getTotalAmount())
          .titleLexend(size: 16)
      }
    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
  }

}

#Preview {
  PaymentView(
    store: PaymentStore(
      userSessionDataSource: MockUserSessionDataSource(),
      lawyerInfoViewModel: .init(),
      orderProcessRepository: MockOrderProcessRepository(),
      paymentRepository: MockPaymentRepository(),
      treatmentRepository: MockTreatmentRepository()
    )
  )
}
