//
//  LoginBottomSheetContentView.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 14/05/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct LoginBottomSheetContentView: View {

  @ObservedObject var store: HomeStore
  
  public init(store: HomeStore) {
    self.store = store
  }
  
  public var body: some View {
    
    VStack(spacing: 16) {
      Text("Masuk Akun Perqara")
        .titleLexend(size: 20)
        .padding(.bottom, 8)
      
      StandardTextField(
        title: "Nomor Ponsel atau Email",
        placeHolder: "contoh@email.com / 0812345678",
        value: $store.username,
        errorMessage: $store.usernameErrorMessage,
        errorColor: $store.errorColor,
        isEnabled: true
      )
      
      ButtonPrimary(
        title: "Masuk",
        color: .buttonActiveColor,
        width: .infinity,
        height: 48
      ) {
        Task {
          await store.requestLogin()
        }
      }
      .padding(.top, 8)
      
      HStack {
        Text("Belum punya akun Perqara?")
          .captionLexend(size: 16)
        Button {
          
        } label: {
          Text("Daftar disini")
            .foregroundStyle(Color.primaryInfo600)
            .captionLexend(size: 16)
        }
        
      }
      
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 8)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .padding(.bottom, 85)
  }
  
}
