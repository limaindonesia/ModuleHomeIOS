//
//  BannerResponseModel.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 31/10/24.
//

import Foundation

// MARK: - BannerResponseModel
public struct BannerResponseModel: Codable {
  let success: Bool?
  let data: DataClass?
  let message: String?
  
  public init() {
    self.success = false
    self.data = nil
    self.message = ""
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(DataClass.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
  
  // MARK: - DataClass
  public struct DataClass: Codable {
    let banner: [Banner]?
    let popup: Popup?
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.banner = try container.decodeIfPresent([Banner].self, forKey: .banner)
      self.popup = try container.decodeIfPresent(Popup.self, forKey: .popup)
    }
  }
  
  // MARK: - Banner
  public struct Banner: Codable {
    let id: Int?
    let title, description, imgURL: String?
    let mobileImgURL: String?
    let webLink, deepLink, startDate, endDate: String?
    let status, createdBy, updatedBy: Int?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
      case id, title, description
      case imgURL = "img_url"
      case mobileImgURL = "mobile_img_url"
      case webLink = "web_link"
      case deepLink = "deep_link"
      case startDate = "start_date"
      case endDate = "end_date"
      case status
      case createdBy = "created_by"
      case updatedBy = "updated_by"
      case createdAt = "created_at"
      case updatedAt = "updated_at"
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: .id)
      self.title = try container.decodeIfPresent(String.self, forKey: .title)
      self.description = try container.decodeIfPresent(String.self, forKey: .description)
      self.imgURL = try container.decodeIfPresent(String.self, forKey: .imgURL)
      self.mobileImgURL = try container.decodeIfPresent(String.self, forKey: .mobileImgURL)
      self.webLink = try container.decodeIfPresent(String.self, forKey: .webLink)
      self.deepLink = try container.decodeIfPresent(String.self, forKey: .deepLink)
      self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
      self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
      self.status = try container.decodeIfPresent(Int.self, forKey: .status)
      self.createdBy = try container.decodeIfPresent(Int.self, forKey: .createdBy)
      self.updatedBy = try container.decodeIfPresent(Int.self, forKey: .updatedBy)
      self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
      self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }
  }
  
  // MARK: - Popup
  public struct Popup: Codable {
    let imgURL, mobileImgURL: String?
    
    enum CodingKeys: String, CodingKey {
      case imgURL = "img_url"
      case mobileImgURL = "mobile_img_url"
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.imgURL = try container.decodeIfPresent(String.self, forKey: .imgURL)
      self.mobileImgURL = try container.decodeIfPresent(String.self, forKey: .mobileImgURL)
    }
  }
  
  
}

