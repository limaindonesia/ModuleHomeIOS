//
//  KemenPPPARepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

public class KemenPPPARepositoryImpl: KemenPPPARepositoryLogic {
  
  public func fetchCategories() async throws -> [ViolenceCategoryEntity] {
    return [
      .init(
        id: 1,
        title: "Kekerasan Berbasis Gender Siber (KBGS)",
        description: "Termasuk pemukulan, penyiksaan, atau tindakan fisik..."
      ),
      .init(
        id: 2,
        title: "Kekerasan Fisik",
        description: "Tindakan menyakiti tubuh secara langsung."
      ),
      .init(
        id: 3,
        title: "Kekerasan Psikis",
        description: "Bentuk intimidasi, ancaman atau tekanan mental."
      ),
      .init(
        id: 4,
        title: "Kekerasan Seksual",
        description: "Pemaksaan hubungan atau tindakan seksual."
      ),
      .init(
        id: 5,
        title: "Eksploitasi Ekonomi",
        description: "Paksaan kerja tanpa imbalan atau eksploitasi finansial."
      )
    ]
  }
  
  public func fetchReasonsKemenPPPA() async throws -> [ReasonEntity] {
    return [
      .init(id: 1, title: "Adanya Perkembangan Kasus / Bukti Tambahan"),
      .init(id: 2, title: "Membutuhkan Pendapat Lain"),
      .init(id: 3, title: "Lainnya")
    ]
  }
  
  public func fetchPrivacyPolicyKemenPPPA() async throws -> String {
    return """
    <ol><li>Bahwa informasi dan data yang saya isi adalah benar, akurat, dan dapat dipertanggungjawabkan.</li><li>Menyetujui bahwa seluruh data dan informasi yang telah saya atau keluarga saya berikan dapat dicatat, direkam dan/atau ditulis dalam laporan Kementerian Pemberdayaan Perempuan dan Perlindungan Anak (&ldquo;KemenPPPA&rdquo;).</li><li>Menyetujui bahwa seluruh data dan informasi yang telah saya isi akan diberikan kepada Peradi dan KemenPPPA guna penanganan kasus lebih lanjut.</li><li>Bersedia memperoleh layanan konsultasi hukum yang disediakan oleh Perqara.</li><li>Bersedia dihubungi oleh advokat PERADI dan/atau KemenPPPA untuk pendampingan lebih lanjut.</li><li>Semua informasi yang telah diberikan wajib dijaga kerahasiaannya oleh pihak-pihak terkait dalam hal penanganan kesulitan/masalah yang saya sampaikan.</li><li>Apabila ada orang/pihak lain yang diperlukan untuk membantu menangani kesulitan/masalah saya, maka orang/pihak tersebut dapat mengetahui kesulitan/masalah saya termasuk laporan yang telah ditulis, sepanjang saya diberitahu.</li><li>Saya bersedia membantu pihak-pihak terkait untuk berdiskusi bersama tentang cara terbaik untuk menyelesaikan kesulitan/masalah saya.</li><li>&nbsp;Apabila kesulitan/masalah saya telah terselesaikan maka pihak-pihak terkait akan berhenti ditugaskan membantu saya dan keluarga.</li><li>Apabila saya menghadapi kesulitan lain, saya diperbolehkan menghubungi pihak-pihak terkait, seperti namun tidak terbatas pada advokat Peradi, dan/atau SAPA 129.</li><li>Apabila masalah yang saya hadapi merupakan kewenangan daerah dimana merupakan lokasi kejadian, maka saya siap dirujuk ke lembaga layanan di daerah tersebut.</li><li>Apabila dalam kurun waktu tertentu, saya tidak merespon advokat PERADI untuk penanganan kesulitan/masalah saya lebih lanjut sebagaimana yang direkomendasikan setelah sesi konsultasi hukum. Maka saya bersedia jika kasus saya dilakukan penghentian.</li></ol>
    """
  }
  
}
