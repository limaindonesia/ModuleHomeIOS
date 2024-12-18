//
//  AppsFlyerConfig.swift
//  Perqara - Clients
//
//  Created by antonius krisna sahadewa on 02/08/24.
//

import Foundation
import AppsFlyerLib
import UIKit
import Environment

var AppleAppsFlyerConfigID: String {
  switch Environment.shared.name {
  case .dev:
    return "6443946589"
  case .staging:
    return "6443946589"
  case .production :
    return "6443946589"
  case .local:
    return "6443946589"
  default: return ""
  }
}

var AppsFlyerConfigKey : String {
  return "BNnuqr3wc2q4tV2oo6hwV"
}

struct AppsFlyerModel{
  var nameEvent : String = ""
  var valueEvent : NSDictionary = ["":""]
}

class AppsFlyerConfig {
  
  static func postEvent(model : AppsFlyerModel){
    AppsFlyerLib.shared().logEvent(model.nameEvent, withValues: model.valueEvent as? [AnyHashable : Any])
  }
  
  static func postEventValueEventNil(event:AppsFlyerEnum){
    AppsFlyerLib.shared().logEvent(event.rawValue, withValues: nil)
  }
  
  static func postEventAFlogin(){
    AppsFlyerLib.shared().logEvent(AFEventLogin, withValues: nil)
  }
}

extension AppsFlyerConfig {
  //MARK: func AppsFlyer login-signup
  static func trackingRegisterSubmit(event:AppsFlyerEnum ,emailOrPhone : String){
    let paramEvent = ["af_email_or_phone_client":emailOrPhone]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingLoginSubmit(event:AppsFlyerEnum ,emailOrPhone : String){
    let paramEvent = ["af_email_or_phone_client":emailOrPhone]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingOTPSubmit(event:AppsFlyerEnum ,emailOrPhone : String){
    let paramEvent = ["af_email_or_phone_client":emailOrPhone]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  
  static func trackingCariAdvokatByKategori(event:AppsFlyerEnum ,kategori : String){
    let paramEvent = ["af_nama_kategori":kategori]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingCariAdvokatByProvinsi(event:AppsFlyerEnum ,provinsi : String){
    let paramEvent = ["af_nama_provinsi":provinsi]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingCariAdvokatByKota(event:AppsFlyerEnum ,kota : String){
    let paramEvent = ["af_nama_kota":kota]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingCariAdvokatByHarga(event:AppsFlyerEnum ,harga : String){
    let paramEvent = ["af_range_harga":harga]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  
  static func trackingDetailAdvocate(event:AppsFlyerEnum ,nameAdvocate : String){
    let paramEvent = ["af_nama_advokat":nameAdvocate]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingPilihKategori(event:AppsFlyerEnum ,kategori : String){
    let paramEvent = ["af_nama_kategori":kategori]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingUseProbono(event: AppsFlyerEnum,
                                 nameAdvocate: String,
                                 skillCategory: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingUsePaid(event: AppsFlyerEnum,
                              nameAdvocate: String,
                              skillCategory: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingOrderKonsultasi(event: AppsFlyerEnum,
                                      nameAdvocate: String,
                                      skillCategory: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingKonsultasiAdvokat(event:AppsFlyerEnum ,nameAdvocate : String){
    let paramEvent = ["af_nama_advokat":nameAdvocate]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingProsesPembayaran(event: AppsFlyerEnum,
                                       nameAdvocate: String,
                                       skillCategory: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingKonfirmasiPembayaran(event: AppsFlyerEnum,
                                           nameAdvocate: String,
                                           skillCategory: String,
                                           idConsult: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory,
                      "af_id_konsultasi":idConsult]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingWaitingRoom(event: AppsFlyerEnum,
                                  nameAdvocate: String,
                                  skillCategory: String,
                                  idConsult: String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory,
                      "af_id_konsultasi":idConsult]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingChatRoom(event: AppsFlyerEnum,
                               nameAdvocate: String,
                               skillCategory: String,
                               idConsult: String,
                               username:String){
    let paramEvent = ["af_nama_advokat":nameAdvocate,
                      "af_nama_kategori":skillCategory,
                      "af_id_konsultasi":idConsult,
                      "af_email_or_phone_client":username]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingButonCobaLagi(event: AppsFlyerEnum,
                                    username: String,
                                    idConsult: String){
    let paramEvent = ["af_id_konsultasi":idConsult,
                      "af_email_or_phone_client":username]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingCancelConsult(event: AppsFlyerEnum,
                                    username: String,
                                    idConsult: String){
    let paramEvent = ["af_id_konsultasi":idConsult,
                      "af_email_or_phone_client":username]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
  
  static func trackingConfrimCancelConsult(event: AppsFlyerEnum,
                                           opsiCancell: String,
                                           username: String,
                                           idConsult: String){
    let paramEvent = ["af_opsi_pembatalan":opsiCancell,
                      "af_email_or_phone_client":username,
                      "af_id_konsultasi":idConsult]
    postEvent(model: AppsFlyerModel(nameEvent: event.rawValue, valueEvent: paramEvent as NSDictionary))
  }
}
