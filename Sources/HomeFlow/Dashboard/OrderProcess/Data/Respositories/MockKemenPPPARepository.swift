//
//  MockKemenPPPARepository.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import AprodhitKit

public class MockKemenPPPARepository: KemenPPPARepositoryLogic {
  
  public init() {}
  
  public func fetchCategories(headers: HeaderRequest) async throws -> [ViolenceCategoryEntity] {
    return [
      .init(
        id: 1,
        title: "Kekerasan Fisik dan Psikis",
        description: "Termasuk pemukulan, penyiksaan, atau tindakan fisik lain yang menyakiti perempuan dan/atau anak, maupun kekerasan psikis yang berupa ancaman, intimidasi, atau perlakuan yang menyebabkan trauma mental."
      ),
      .init(
        id: 2,
        title: "Kekerasan Seksual",
        description: "Pelecehan, pemaksaan hubungan seksual, atau tindakan lain yang bersifat seksual tanpa persetujuan."
      ),
      .init(
        id: 3,
        title: "Kekerasan Berbasis Gender Siber (KBGS)",
        description: "Ancaman atau penyebaran materi seksual secara daring, termasuk oleh mantan pasangan atau akun anonim ."
      ),
      .init(
        id: 4,
        title: "Eksploitasi dan Perdagangan Orang (TPPO)",
        description: "Kasus eksploitasi seksual, pekerja anak, atau perdagangan perempuan dan anak."
      ),
      .init(
        id: 5,
        title: "Penelantaran Anak",
        description: "Ketidakpedulian terhadap kebutuhan dasar anak, termasuk makanan, pendidikan, dan perlindungan."
      ),
      .init(
        id: 6,
        title: "Perkawinan Anak",
        description: "Pernikahan yang melibatkan anak di bawah umur, yang melanggar hak-hak anak."
      ),
      .init(
        id: 7,
        title: "Anak Berhadapan dengan Hukum (ABH)",
        description: "Anak yang menjadi pelaku, korban, atau saksi dalam proses hukum."
      ),
      .init(
        id: 8,
        title: "Diskriminasi terhadap Perempuan dan Anak",
        description: "Perlakuan tidak adil berdasarkan gender atau usia dalam berbagai aspek kehidupan."
      ),
      .init(
        id: 9,
        title: "Kekerasan dalam Rumah Tangga (KDRT)",
        description: "Segala bentuk kekerasan yang terjadi dalam lingkungan keluarga."
      ),
      .init(
        id: 10,
        title: "Kasus Anak Berkebutuhan Khusus (ABK)",
        description: "Perlindungan terhadap anak dengan disabilitas atau kebutuhan khusus."
      ),
      .init(
        id: 11,
        title: "Kasus Perempuan dalam Situasi Khusus",
        description: "Perempuan penyintas bencana, konflik sosial, atau imigran."
      )
    ]
  }
  
  public func fetchReasonsKemenPPPA(headers: HeaderRequest) async throws -> [ReasonEntity] {
    return [
      .init(id: 1, title: "Adanya Perkembangan Kasus / Bukti Tambahan"),
      .init(id: 2, title: "Membutuhkan Pendapat Lain"),
      .init(id: 3, title: "Lainnya")
    ]
  }
  
  public func fetchPrivacyPolicyKemenPPPA(headers: HeaderRequest) async throws -> String {
    return """
    <ol><li>Bahwa informasi dan data yang saya isi adalah benar, akurat, dan dapat dipertanggungjawabkan.</li><li>Menyetujui bahwa seluruh data dan informasi yang telah saya atau keluarga saya berikan dapat dicatat, direkam dan/atau ditulis dalam laporan Kementerian Pemberdayaan Perempuan dan Perlindungan Anak (&ldquo;KemenPPPA&rdquo;).</li><li>Menyetujui bahwa seluruh data dan informasi yang telah saya isi akan diberikan kepada Peradi dan KemenPPPA guna penanganan kasus lebih lanjut.</li><li>Bersedia memperoleh layanan konsultasi hukum yang disediakan oleh Perqara.</li><li>Bersedia dihubungi oleh advokat PERADI dan/atau KemenPPPA untuk pendampingan lebih lanjut.</li><li>Semua informasi yang telah diberikan wajib dijaga kerahasiaannya oleh pihak-pihak terkait dalam hal penanganan kesulitan/masalah yang saya sampaikan.</li><li>Apabila ada orang/pihak lain yang diperlukan untuk membantu menangani kesulitan/masalah saya, maka orang/pihak tersebut dapat mengetahui kesulitan/masalah saya termasuk laporan yang telah ditulis, sepanjang saya diberitahu.</li><li>Saya bersedia membantu pihak-pihak terkait untuk berdiskusi bersama tentang cara terbaik untuk menyelesaikan kesulitan/masalah saya.</li><li>&nbsp;Apabila kesulitan/masalah saya telah terselesaikan maka pihak-pihak terkait akan berhenti ditugaskan membantu saya dan keluarga.</li><li>Apabila saya menghadapi kesulitan lain, saya diperbolehkan menghubungi pihak-pihak terkait, seperti namun tidak terbatas pada advokat Peradi, dan/atau SAPA 129.</li><li>Apabila masalah yang saya hadapi merupakan kewenangan daerah dimana merupakan lokasi kejadian, maka saya siap dirujuk ke lembaga layanan di daerah tersebut.</li><li>Apabila dalam kurun waktu tertentu, saya tidak merespon advokat PERADI untuk penanganan kesulitan/masalah saya lebih lanjut sebagaimana yang direkomendasikan setelah sesi konsultasi hukum. Maka saya bersedia jika kasus saya dilakukan penghentian.</li></ol>
    """
  }
  
  public func requestCreateConsultationKemenPPPA(
    headers: HeaderRequest,
    params: Paramable
  ) async throws -> String {
    return ""
  }
}
