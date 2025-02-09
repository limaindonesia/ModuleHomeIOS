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
import Kingfisher

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
          price: store.getPriceBottom(),
          totalAdjustment: store.getTotalAdjustment(),
          buttonText: "Bayar",
          isVoucherApplied: store.voucherFilled,
          isButtonActive: store.isPayButtonActive,
          onTap: {
            store.navigateToNextDestination()
          }
        )
        .padding(.horizontal, 16)
      }
      
      BottomSheetNewView(isPresented: $store.isPresentVoucherTnCBottomSheet) {
        VoucherTnCBottomSheetView(voucher: store.eligibleVoucherEntity) { voucher in
          Task {
            store.eligibleVoucherEntity = voucher
            store.updateVoucherArrays()
            store.hideVoucherTncBottomSheet()
            store.showVoucherBottomSheet()
            await store.applyVoucher(voucher.code)
          }
        }
      }
      
      BottomSheetView(isPresented: $store.isPresentVoucherBottomSheet) {
        VoucherBottomSheetView(
          activateButton: $store.activateButton,
          voucher: $store.voucherCode,
          showXMark: $store.showXMark,
          voucherErrorText: $store.voucherErrorText,
          vouchers: $store.elligibleVoucherEntities,
          onTap: { code in
            Task {
              await store.applyVoucher(code)
            }
          }, onUseVoucher: { voucher in
            Task {
              store.eligibleVoucherEntity = voucher
              await store.applyVoucher(voucher.code)
            }
          }, onCancelVoucher: { _ in
            Task {
              await store.removeVoucher()
            }
          },
          onClear: {
            Task {
              await store.removeVoucher()
            }
          },
          onTapTnC: { voucher in
            store.eligibleVoucherEntity = voucher
            store.showVoucherTnCBottomSheet()
            store.hideVoucherBottomSheet()
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
          }
          .frame(height: frame.height/2)
          .padding(.horizontal, 16)
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
      
      BottomSheetView(isPresented: $store.isPresentWarningPaymentBottomSheet) {
        WarningPaymentContentView(
          totalAdjustment: store.getTotalAdjustment(),
          onCancelled: {
            store.showReasonBottomSheet()
            store.hideWarningPaymentBottomSheet()
          },
          onPayment: {
            store.hideWarningPaymentBottomSheet()
          }
        )
      }
      
      BottomSheetView(
        isPresented: $store.isPresentReasonBottomSheet,
        dismissable: true
      ) {
        CancelationReasonContentView(
          store: CancelationReasonStore(
            arrayReasons: store.reasons
          ),
          imageURL: store.getAvatarImage(),
          lawyerName: store.getLawyersName(),
          onSendReason: { (entity, reason) in
            store.selectedReason = entity
            store.reason = reason
            Task {
              await store.requestCancelation()
            }
            
            GLogger(
              .info,
              layer: "Presentation",
              message: "send reason \(entity.id) : \( entity.title) : \(reason)"
            )
          }
        )
        
      } onDismissed: {
        Task {
          await store.onDismissedReasonBottomSheet()
        }
      }
      
      BottomSheetView(
        isPresented: $store.isPresentDetailConsultationBottomSheet,
        dismissable: true
      ) {
        DetailConsultationContentView(
          category: store.getCategoryBottomSheet(),
          duration: store.getDurationBottomSheet(),
          type: store.getTypeBottomSheet(),
          desc: store.getDetailIssueName()
        )
      } onDismissed: {
      }
      
    }
    
  }
  
  @ViewBuilder
  func lawyerInfoView(
    orderID: String,
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
          
          if store.showTimeRemainig {
            TimerTextView(paymentTimeRemaining: store.paymentTimeRemaining.value) { newValue in
              store.paymentTimeRemaining.value = newValue
            } onTimerTimeUp: {
              
            }
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
          Text("Detail Konsultasi")
            .foregroundColor(.darkTextColor)
            .captionLexend(size: 14)
          
          Spacer()
          
          Button {
            store.showDetailConsultationBottomSheet()
          } label: {
            Image("ic_down_arrow", bundle: .module)
          }
          
        }
        .padding(.horizontal, 7)
        
      }
      .padding(.horizontal, 7)
      .padding(.vertical, 13)
      .frame(maxWidth: .infinity, minHeight: 40)
      .background(Color.gray050)
      .cornerRadius(8)
      .padding(.horizontal, 12)
      
      HStack(spacing: 8) {
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
      voucherCode(voucherCount: store.voucherCountInfo){
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
  func voucherCode(
    voucherCount: String,
    onTap: @escaping () -> Void
  ) -> some View {
    VStack(alignment: .leading) {
      Text("Kode Promo dan Voucher")
        .titleLexend(size: 16)
      
      HStack(spacing: 10) {
        Image("ticket_discount", bundle: .module)
        
        Text("Pilih atau tulis kode")
          .foregroundColor(Color.gray500)
          .titleLexend(size: 14)
        
        Spacer()
        
        Text(voucherCount)
          .foregroundStyle(Color.primaryInfo700)
          .captionLexend(size: 10)
        
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
    VStack(alignment: .leading, spacing: 12) {
      Text("Pilih Metode Pembayaran")
        .foregroundColor(Color.darkTextColor)
        .titleLexend(size: 14)
      
      HStack {
        Text("Pembayaran akan dilakukan di halaman")
          .foregroundColor(Color.darkGray400)
          .captionLexend(size: 12)
        
        Image("ic_xendit", bundle: .module)
      }
      
      virtualAccountOptions()
      
      eWalletOptions()
      
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
      Text("Rincian Biaya")
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
        Text("Total Biaya")
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
  
  @ViewBuilder
  func virtualAccountOptions() -> some View {
    VStack(alignment: .leading) {
      
      HStack {
        Text("Virtual Account")
          .titleLexend(size: 14)
        
        Spacer()
        
        CheckboxCheckListView(
          isSelected: store.isVirtualAccountChecked,
          action: {
            withAnimation(.smooth) {
              store.checkVirtualAccount()
              store.selectedPaymentCategory = .VA
            }
          }
        )
      }
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray200)
      
      HStack {
        ForEach(store.getVAs(), id: \.id) { item in
          KFImage(item.icon)
        }
      }
      
    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(
      store.isVirtualAccountChecked
      ? Color.primaryInfo050
      : Color.white
    )
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(
        Color.primaryInfo200,
        lineWidth: store.isVirtualAccountChecked ? 1.5 : 0
      )
    }
    .shadow(color: Color.gray100, radius: 5)
  }
  
  @ViewBuilder
  func eWalletOptions() -> some View {
    VStack(alignment: .leading) {
      
      HStack {
        Text("E-Wallet")
          .titleLexend(size: 14)
        
        Spacer()
        
        CheckboxCheckListView(
          isSelected: store.isEWalletChecked,
          action: {
            withAnimation(.smooth) {
              store.checkEWallet()
              store.selectedPaymentCategory = .EWALLET
            }
          }
        )
      }
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray200)
      
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: true) {
          HStack {
            ForEach(store.getEWallets(), id: \.id) { item in
              KFImage(item.icon)
            }
          }
          .onAppear {
            DispatchQueue.main.async {
              proxy.scrollTo(0, anchor: .center)
            }
          }
        }
      }
      
    }
    .padding(.all, 12)
    .frame(maxWidth: .infinity)
    .background(
      store.isEWalletChecked
      ? Color.primaryInfo050
      : Color.white
    )
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(
        Color.primaryInfo200,
        lineWidth: store.isEWalletChecked ? 1.5 : 0
      )
    }
    .shadow(color: Color.gray100, radius: 5)
  }
  
}

#Preview {
  PaymentView(store: .init())
}
