//
//  PaymentView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI
import AprodhitKit
import GnDKit
import Lottie

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
              timeRemaining: store.paymentTimeRemaining.timeString(),
              imageURL: store.getAvatarImage(),
              name: store.getLawyersName(),
              agency: store.getAgency(),
              consultationTime: store.timeConsultation,
              showDetailIssues: store.showDetailIssues,
              detailIssues: store.getDetailIssue()
            )

            if !store.isProbono() {
              showVoucherView {
                store.showVoucherBottomSheet()
              } onTapTNC: {
                store.showTNCBottomSheet()
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
          totalAdjustment: store.getTotalAdjustment(),
          buttonText: "Bayar",
          isVoucherApplied: store.voucherFilled,
          onTap: {
            store.navigateToNextDestination()
          }
        )
        .padding(.horizontal, 16)
      }

      BottomSheetView(isPresented: $store.isPresentVoucherBottomSheet) {
        VoucherBottomSheetView(
          activateButton: $store.activateButton,
          voucher: $store.voucherCode,
          showXMark: $store.showXMark,
          voucherErrorText: $store.voucherErrorText,
          onTap: { voucher in
            Task { 
              await store.applyVoucher()
            }
          },
          onClear: {
            Task {
              await store.removeVoucher()
            }
          }
        )
      }
      
      BottomSheetView(
        isPresented: $store.isPresentMakeSureBottomSheet,
        dismissable: true
      ) {
        WarningBottomSheetView {
          store.dismissWaningBottomSheet()
        } onTapQuit: {
          store.dismissWaningBottomSheet()
          store.backToHome()
        }
      }

      GeometryReader { proxy in
        let frame = proxy.frame(in: .local)
        
        BottomSheetView(isPresented: $store.isPresentTncBottomSheet) {
          VStack {
            VoucherTNCView(text: store.getTNCVoucher())
          }.frame(height: frame.height/2)
        }
      }
      
      if store.isLoading {
        BlurView(style: .dark)
        
        LottieView {
          LottieAnimation.named("perqara-loading", bundle: .module)
        }
        .looping()
        .frame(width: 72, height: 72)
        .padding(.bottom, 50)
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
    consultationTime: String,
    showDetailIssues: Bool,
    detailIssues: String
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
            .onReceive(store.timer) { _ in
              store.receiveTimer()
            }
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

      VStack(alignment: .leading) {
        HStack {
          Text("Detail")
            .foregroundColor(.darkTextColor)
            .titleLexend(size: 12)
          
          Spacer()
          
          Button {
            store.showDetailIssues.toggle()
          } label: {
            Image("ic_down_arrow", bundle: .module)
          }
          
        }
        .padding(.horizontal, 7)
        
        if showDetailIssues {
          Text(detailIssues)
            .foregroundColor(Color.darkTextColor)
            .bodyLexend(size: 14)
            .padding(.horizontal, 7)
        }
        
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
  func showVoucherView(
    onTapVoucher: @escaping () -> Void,
    onTapTNC: @escaping () -> Void
  ) -> some View {
    
    if store.voucherFilled {
      voucherCodeFilled {
        onTapVoucher()
      } onTapTnc: {
        onTapTNC()
      }
    } else {
      voucherCode {
        onTapVoucher()
      }
    }
    
  }

  @ViewBuilder
  func voucherCodeFilled(
    onTap: @escaping () -> Void,
    onTapTnc: @escaping () -> Void
  ) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Kode Promo dan Voucher")
        .titleLexend(size: 16)

      HStack(spacing: 10) {
        Image("ticket_discount", bundle: .module)

        Text(store.voucherViewModel.code)
          .foregroundColor(Color.darkTextColor)
          .titleLexend(size: 14)

        Spacer()

        Text(store.getVoucherText())
          .foregroundColor(Color.gray700)
          .bodyLexend(size: 10)

        Image("ic_chevron", bundle: .module)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.primaryInfo050)
      .cornerRadius(8)

      Text(store.getVoucherDuration())
        .foregroundColor(Color.gray500)
        .bodyLexend(size: 10)

      Button {
        onTapTnc()
      } label: {
        Text("Lihat Syarat dan Ketentuan")
          .foregroundColor(Color.buttonActiveColor)
          .bodyLexend(size: 12)
      }
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
    VStack(alignment: .leading, spacing: 8) {
      Text("Metode Pembayaran")
        .foregroundColor(Color.darkTextColor)
        .titleLexend(size: 14)

      Text("Anda akan memilih metode pembayaran dihalaman selanjutnya")
        .foregroundColor(Color.gray600)
        .bodyLexend(size: 12)

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
          name: fee.getName(),
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
  PaymentView(store: .init())
}
