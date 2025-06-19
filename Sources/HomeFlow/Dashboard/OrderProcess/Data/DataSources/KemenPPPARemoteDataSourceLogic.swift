//
//  KemenPPPARemoteDataSourceLogic.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 18/06/25.
//

import Foundation
import AprodhitKit

public protocol KemenPPPARemoteDataSourceLogic {
  func fetchCategories(headers: [String : String]) async throws -> [ViolenceCategoryEntity]
  func fetchReasonsKemenPPPA(headers: [String : String]) async throws -> ReasonResponseModel
  func fetchPrivacyPolicyKemenPPPA(headers: [String : String]) async throws -> String
  func requestCreateConsultationKemenPPPA(
    headers: [String : String],
    params: [String : Any]
  ) async throws -> String
}

public class KemenPPPARemoteDataSourceImpl: KemenPPPARemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchCategories(headers: [String : String]) async throws -> [ViolenceCategoryEntity] {
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
  
  public func fetchReasonsKemenPPPA(headers: [String : String]) async throws -> ReasonResponseModel {
    do {
      let data = try await service.request(
        with: Endpoint.REASON_KEMENPPPA,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      let json = try JSONDecoder().decode(ReasonResponseModel.self, from: data)
      return json
    } catch {
      throw error
    }
  }
  
  public func fetchPrivacyPolicyKemenPPPA(headers: [String : String]) async throws -> String {
    var result: String = ""
    
    do {
      let data = try await service.request(
        with: Endpoint.PRIVACY_POLICY_KEMENPPPA,
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let data = json["data"] as? [String : Any] {
          if let content = data["content"] as? String {
            result = content
          }
        }
      }
    } catch {
      throw error
    }
    
    return result
  }
  
  public func requestCreateConsultationKemenPPPA(
    headers: [String : String],
    params: [String : Any]
  ) async throws -> String {
    
    var roomKey: String = ""
    
    do {
      let data = try await service.request(
        with: Endpoint.CREATE_CONSULTATION_KEMENPPPA,
        withMethod: .post,
        withHeaders: headers,
        withParameter: params,
        withEncoding: .json
      )
      
      let response = try JSONSerialization.jsonObject(with: data)
      if let json = response as? [String : Any] {
        if let data = json["data"] as? [String : Any] {
          if let content = data["room_key"] as? String {
            roomKey = content
          }
        }
      }
    } catch {
      throw error
    }
    
    return roomKey
    
  }
  
}
