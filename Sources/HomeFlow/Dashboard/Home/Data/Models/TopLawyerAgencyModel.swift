//
//  TopLawyerAgencyModel.swift
//
//
//  Created by Ilham Prabawa on 10/10/24.
//

import Foundation

// MARK: - TopLawyerAgencyModel
public struct TopLawyerAgencyModel: Codable {
  let success: Bool?
  let data: DataModel?
  let message: String?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent(TopLawyerAgencyModel.DataModel.self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }

  // MARK: - DataClass
  public struct DataModel: Codable {
    let year, month: Int?
    let agencies: [Agency]?
    let lawyers: [Lawyer]?
    let status: String?

    enum CodingKeys: CodingKey {
      case year
      case month
      case agencies
      case lawyers
      case status
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<TopLawyerAgencyModel.DataModel.CodingKeys> = try decoder.container(keyedBy: TopLawyerAgencyModel.DataModel.CodingKeys.self)
      self.year = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.DataModel.CodingKeys.year)
      self.month = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.DataModel.CodingKeys.month)
      self.agencies = try container.decodeIfPresent([TopLawyerAgencyModel.Agency].self, forKey: TopLawyerAgencyModel.DataModel.CodingKeys.agencies)
      self.lawyers = try container.decodeIfPresent([TopLawyerAgencyModel.Lawyer].self, forKey: TopLawyerAgencyModel.DataModel.CodingKeys.lawyers)
      self.status = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.DataModel.CodingKeys.status)
    }

  }

  // MARK: - Agency
  public struct Agency: Codable {
    public let pos: Int?
    public let agency, location: String?

    enum CodingKeys: CodingKey {
      case pos
      case agency
      case location
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<TopLawyerAgencyModel.Agency.CodingKeys> = try decoder.container(keyedBy: TopLawyerAgencyModel.Agency.CodingKeys.self)
      self.pos = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.Agency.CodingKeys.pos)
      self.agency = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.Agency.CodingKeys.agency)
      self.location = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.Agency.CodingKeys.location)
    }
  }

  // MARK: - Lawyer
  public struct Lawyer: Codable {
    let pos, lawyerID: Int?
    let name: String?
    let image: String?
    let agency: String?
    let yearExp: Int?

    enum CodingKeys: String, CodingKey {
      case pos
      case lawyerID = "lawyerId"
      case name, image, agency, yearExp
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<TopLawyerAgencyModel.Lawyer.CodingKeys> = try decoder.container(keyedBy: TopLawyerAgencyModel.Lawyer.CodingKeys.self)
      self.pos = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.pos)
      self.lawyerID = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.lawyerID)
      self.name = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.name)
      self.image = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.image)
      self.agency = try container.decodeIfPresent(String.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.agency)
      self.yearExp = try container.decodeIfPresent(Int.self, forKey: TopLawyerAgencyModel.Lawyer.CodingKeys.yearExp)
    }

  }

}

