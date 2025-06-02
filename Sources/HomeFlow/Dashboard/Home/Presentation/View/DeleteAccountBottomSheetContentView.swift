//
//  DeleteAccountBottomSheetContentView.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 02/06/25.
//


import SwiftUI
import AprodhitKit
import GnDKit

public struct DeleteAccountBottomSheetContentView: View {

  @ObservedObject var store: HomeStore
  
  public init(store: HomeStore) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Text("Akun Anda Berhasil Dihapus")
        .titleLexend(size: 20)
        .padding(.bottom, 10)
        .frame(alignment: .leading)
      
      Text("Akun Anda telah dihapus secara permanen. Anda tidak dapat lagi login dan mengakses data histori Anda di Perqara.")
        .captionLexend(size: 16)
        .padding(.bottom, 10)
        .frame(alignment: .leading)
      
      ButtonPrimary(
        title: "Tutup",
        color: .buttonActiveColor,
        width: .infinity,
        height: 48
      ) {
        Task {
          await store.hideSuccessDeleteAccount()
        }
      }
      .padding(.top, 8)
    }
    .padding(.trailing, 10)
    .padding(.leading, 10)
    .padding(.top, 4)
    .padding(.bottom, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .padding(.bottom, 100)
  }
  
}
