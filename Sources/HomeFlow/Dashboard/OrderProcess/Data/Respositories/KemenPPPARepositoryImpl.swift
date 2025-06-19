//
//  KemenPPPARepositoryImpl.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import GnDKit
import AprodhitKit

public class KemenPPPARepositoryImpl: KemenPPPARepositoryLogic {
  
  private let remote: KemenPPPARemoteDataSourceLogic
  
  public init(remote: KemenPPPARemoteDataSourceLogic) {
    self.remote = remote
  }
  
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
    do {
      let response = try await remote.fetchReasonsKemenPPPA(headers: headers.toHeaders())
      return response.data?.map(ReasonEntity.map(from:)) ?? []
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
  public func fetchPrivacyPolicyKemenPPPA(headers: HeaderRequest) async throws -> String {
    do {
      let response = try await remote.fetchPrivacyPolicyKemenPPPA(headers: headers.toHeaders())
      return response.wrappedInHTML
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
  public func requestCreateConsultationKemenPPPA(
    headers: HeaderRequest,
    params: Paramable
  ) async throws -> String {
    do {
      let response = try await remote.requestCreateConsultationKemenPPPA(
        headers: headers.toHeaders(),
        params: params.toParam()
      )
      return response
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Perhatian",
        message: error.description
      )
    }
  }
  
}
