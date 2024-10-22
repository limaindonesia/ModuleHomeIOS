//
//  NewestArticleResponseModel.swift
//  Perqara - Clients
//
//  Created by Ilham Prabawa on 15/08/24.
//

import Foundation

public struct NewestArticleResponseModel: Codable {
  let id: Int?
  let date, dateGmt: String?
  let guid: GUID?
  let modified, modifiedGmt, slug: String?
  let status: String?
  let type: String?
  let link: String?
  let title: GUID?
  let content, excerpt: Content?
  let author, featuredMedia: Int?
  let commentStatus, pingStatus: String?
  let sticky: Bool?
  let template: String?
  let format: String?
  let categories, tags: [Int]?
  let featuredImage: String?
  let authorName: String?
  let authorURL: String?
  let links: Links?

  enum CodingKeys: String, CodingKey {
    case id, date
    case dateGmt = "date_gmt"
    case guid, modified
    case modifiedGmt = "modified_gmt"
    case slug, status, type, link, title, content, excerpt, author
    case featuredMedia = "featured_media"
    case commentStatus = "comment_status"
    case pingStatus = "ping_status"
    case sticky, template, format, categories, tags
    case featuredImage = "featured_image"
    case authorName = "author_name"
    case authorURL = "author_url"
    case links = "_links"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.date = try container.decodeIfPresent(String.self, forKey: .date)
    self.dateGmt = try container.decodeIfPresent(String.self, forKey: .dateGmt)
    self.guid = try container.decodeIfPresent(GUID.self, forKey: .guid)
    self.modified = try container.decodeIfPresent(String.self, forKey: .modified)
    self.modifiedGmt = try container.decodeIfPresent(String.self, forKey: .modifiedGmt)
    self.slug = try container.decodeIfPresent(String.self, forKey: .slug)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.type = try container.decodeIfPresent(String.self, forKey: .type)
    self.link = try container.decodeIfPresent(String.self, forKey: .link)
    self.title = try container.decodeIfPresent(GUID.self, forKey: .title)
    self.content = try container.decodeIfPresent(Content.self, forKey: .content)
    self.excerpt = try container.decodeIfPresent(Content.self, forKey: .excerpt)
    self.author = try container.decodeIfPresent(Int.self, forKey: .author)
    self.featuredMedia = try container.decodeIfPresent(Int.self, forKey: .featuredMedia)
    self.commentStatus = try container.decodeIfPresent(String.self, forKey: .commentStatus)
    self.pingStatus = try container.decodeIfPresent(String.self, forKey: .pingStatus)
    self.sticky = try container.decodeIfPresent(Bool.self, forKey: .sticky)
    self.template = try container.decodeIfPresent(String.self, forKey: .template)
    self.format = try container.decodeIfPresent(String.self, forKey: .format)
    self.categories = try container.decodeIfPresent([Int].self, forKey: .categories)
    self.tags = try container.decodeIfPresent([Int].self, forKey: .tags)
    self.featuredImage = try container.decodeIfPresent(String.self, forKey: .featuredImage)
    self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
    self.authorURL = try container.decodeIfPresent(String.self, forKey: .authorURL)
    self.links = try container.decodeIfPresent(Links.self, forKey: .links)
  }

}

// MARK: - Content
public struct Content: Codable {
  let rendered: String?
  let protected: Bool?
}


// MARK: - GUID
public struct GUID: Codable {
  let rendered: String?
}

// MARK: - Links
public struct Links: Codable {
  let linksSelf, collection, about: [About]?
  let author, replies: [Author]?
  let versionHistory: [VersionHistory]?
  let predecessorVersion: [PredecessorVersion]?
  let wpFeaturedmedia: [Author]?
  let wpAttachment: [About]?
  let wpTerm: [WpTerm]?
  let curies: [Cury]?

  enum CodingKeys: String, CodingKey {
    case linksSelf = "self"
    case collection, about, author, replies
    case versionHistory = "version-history"
    case predecessorVersion = "predecessor-version"
    case wpFeaturedmedia = "wp:featuredmedia"
    case wpAttachment = "wp:attachment"
    case wpTerm = "wp:term"
    case curies
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.linksSelf = try container.decodeIfPresent([About].self, forKey: .linksSelf)
    self.collection = try container.decodeIfPresent([About].self, forKey: .collection)
    self.about = try container.decodeIfPresent([About].self, forKey: .about)
    self.author = try container.decodeIfPresent([Author].self, forKey: .author)
    self.replies = try container.decodeIfPresent([Author].self, forKey: .replies)
    self.versionHistory = try container.decodeIfPresent([VersionHistory].self, forKey: .versionHistory)
    self.predecessorVersion = try container.decodeIfPresent([PredecessorVersion].self, forKey: .predecessorVersion)
    self.wpFeaturedmedia = try container.decodeIfPresent([Author].self, forKey: .wpFeaturedmedia)
    self.wpAttachment = try container.decodeIfPresent([About].self, forKey: .wpAttachment)
    self.wpTerm = try container.decodeIfPresent([WpTerm].self, forKey: .wpTerm)
    self.curies = try container.decodeIfPresent([Cury].self, forKey: .curies)
  }

}

// MARK: - About
public struct About: Codable {
  let href: String?
}

// MARK: - Author
public struct Author: Codable {
  let embeddable: Bool?
  let href: String?
}

// MARK: - Cury
public struct Cury: Codable {
  let name: String?
  let href: String?
  let templated: Bool?
}

// MARK: - PredecessorVersion
public struct PredecessorVersion: Codable {
  let id: Int?
  let href: String?
}

// MARK: - VersionHistory
public struct VersionHistory: Codable {
  let count: Int?
  let href: String?
}

// MARK: - WpTerm
public struct WpTerm: Codable {
  let taxonomy: String?
  let embeddable: Bool?
  let href: String?
}
