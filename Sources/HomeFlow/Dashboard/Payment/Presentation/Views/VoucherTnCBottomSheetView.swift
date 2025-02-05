//
//  VoucherTnCBottomSheetView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/02/25.
//

import SwiftUI
import GnDKit
import AprodhitKit

struct VoucherTnCBottomSheetView: View {
  
  @State var contentHeight: CGFloat = 0
  
  let steps = ["Prepare ingredients", "Mix thoroughly", "Bake at 350°F"]
  var htmlText = """
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Numbered List</title>
      <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@100&display=swap" rel="stylesheet">
      <style>
          body {
              font-family: 'Lexend-Light', sans-serif;
              font-weight: 300;
              font-size: 14px;
              marging: 0;
              padding: 0;
          }
          ol {
            display: block;
            list-style-type: decimal;
            margin-top: 1em;
            margin-bottom: 1em;
            margin-left: 0;
            margin-right: 0;
            padding-left: 20px;
          }
      </style>
  </head>
  <body>
      <ol>
          <li>Layanan Probono berlaku pada Layanan Konsultasi Hukum.</li>
          <li>Layanan Probono hanya dapat diberikan kepada Pengguna yang memiliki Kartu Tanda Penduduk (“KTP”).</li>
          <li>Layanan Probono dapat diakses oleh Pengguna dengan cara melampirkan KTP untuk diverifikasi oleh Perqara pada laman situs yang telah disediakan oleh Perqara.</li>
          <li>Pengguna hanya dapat melampirkan 1 (satu) KTP dalam 1 (satu) akun di Perqara.</li>
          <li>KTP yang telah dilampirkan oleh Pengguna tidak dapat dilampirkan kembali pada akun lainnya.</li>
          <li>Setelah KTP diunggah dan berhasil diverifikasi, Pengguna dapat menggunakan Layanan Probono Konsultasi Hukum sebanyak 1 (satu) kali.</li>
          <li>Ketidaksesuaian identitas yang tercantum di dalam KTP dengan profil akun Pengguna akan mengakibatkan permohonan penggunaan Layanan Probono tidak dapat diterima.</li>
          <li>Pengguna dapat mengajukan pengembalian kuota Layanan Probono dalam Layanan Konsultasi Hukum dalam hal terjadinya keadaan sebagai berikut:
          </li>
          <li>Pengajuan pengembalian kuota Layanan Probono hanya dapat diajukan oleh Pengguna selambat-lambatnya 24 (dua puluh empat) jam terhitung setelah konsultasi berakhir.</li>
          <li>Hasil proses investigasi internal oleh tim Perqara akan diberitahukan kepada Pengguna selambat-lambatnya 21 (dua puluh satu) hari kerja setelah pengajuan pengembalian kuota Layanan Probono diajukan oleh Pengguna.</li>
          <li>LIMA berhak untuk mengubah sewaktu-waktu Syarat dan Ketentuan ini, dengan pemberitahuan melalui pengumuman di situs/aplikasi Perqara atau sarana lainnya yang dipandang wajar.</li>
      </ol>
  </body>
  </html>
  """
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        Text("Syarat & Ketentuan")
          .titleLexend(size: 16)
        
        HTMLWebView(
          htmlContent: htmlText,
          contentHeight: $contentHeight
        )
        .frame(height: contentHeight)
      }
      .padding(.horizontal, 16)
    }
  }
}

#Preview {
  VoucherTnCBottomSheetView()
}
