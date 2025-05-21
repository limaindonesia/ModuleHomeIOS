//
//  OTPBottomSheetContentView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 14/05/25.
//

import SwiftUI
import AprodhitKit
import GnDKit
import AprodhitAuthModule

public struct OTPBottomSheetContentView: View {
  
  @ObservedObject public var store: HomeStore
  @FocusState private var focusedIndex: Int?
  
  public var body: some View {
    VStack(spacing: 24) {
      HStack(alignment: .center, spacing: 8) {
        Image(store.getOTPImage(), bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 48, height: 48)
        
        Text(store.getOTPTitle())
          .foregroundStyle(Color.darkTextColor)
          .bodyLexend(size: 14)
      }
      .padding(.horizontal, 8)
      
      Text(store.username)
        .bodyLexend(size: 14)
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(Color.primaryInfo050)
        .clipShape(RoundedRectangle(cornerRadius: 6))
      
      OTPTextView(otp: $store.otp, focusedIndex: focusedIndex)
        .padding(.horizontal, 16)
      
      if store.showTimer {
        HStack(spacing: 4) {
          Text("Dapatkan kode baru setelah")
            .foregroundStyle(Color.darkTextColor)
            .bodyLexend(size: 14)
          
          AprodhitKit.TimerTextView(
            timeRemaining: store.timeRemaining,
            textColor: .primaryInfo600
          ) { value in
            store.timeRemaining = value
          } onTimerTimeUp: {
            store.showTimer = false
          }
        }
      } else {
        Button {
          Task { await store.resendOTP() }
        } label: {
          Text(NSLocalizedString(Constant.Text.RESEND_OTP, comment: ""))
            .foregroundStyle(Color.buttonActiveColor)
            .bodyLexend(size: 14)
        }
      }
      
      if store.isEmail {
        HStack {
          Image("info", bundle: .module)
          Text("Jika tidak menemukan email OTP, mohon periksa folder spam/junk secara berkala")
            .foregroundStyle(Color.warning900)
            .captionLexend(size: 12)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.warning050)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.warning200, lineWidth: 1)
        }
        .padding(.horizontal, 16)
      }
      
      ButtonPrimary(
        title: NSLocalizedString(Constant.Text.LOGIN, comment: ""),
        color: .buttonActiveColor,
        width: .infinity,
        height: 52
      ) {
        Task { await store.requestOTP() }
      }
      .padding(.horizontal, 16)
      
      Divider()
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.gray200)
        .padding(.horizontal, 16)
      
      VStack(spacing: 4) {
        Text(store.getChangeTitle())
          .foregroundStyle(Color.darkTextColor)
          .captionLexend(size: 14)
        
        Button {
          
        } label: {
          Text(store.getButtonChangeTitle())
            .foregroundStyle(Color.buttonActiveColor)
            .titleLexend(size: 12)
        }
        
      }
    }
  }
  
}
