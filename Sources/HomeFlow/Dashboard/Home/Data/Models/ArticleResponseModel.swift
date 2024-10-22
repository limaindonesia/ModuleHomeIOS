//
//  ArticleResponseModel.swift
//
//
//  Created by Ilham Prabawa on 01/08/24.
//

import Foundation

// MARK: - Welcome
public struct ArticleResponseModel: Codable {
  
  public let success: Bool?
  public let message: String?
  public let data: [ArticleData]?

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
    self.data = try container.decodeIfPresent([ArticleResponseModel.ArticleData].self, forKey: .data)
  }

  // MARK: - Datum
  public struct ArticleData: Codable {
    let featuredImage: String?
    let category: [Int]?
    let post: Post?

    enum CodingKeys: String, CodingKey {
      case featuredImage = "featured_image"
      case category, post
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<ArticleResponseModel.ArticleData.CodingKeys> = try decoder.container(keyedBy: ArticleResponseModel.ArticleData.CodingKeys.self)
      self.featuredImage = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.ArticleData.CodingKeys.featuredImage)
      self.category = try container.decodeIfPresent([Int].self, forKey: ArticleResponseModel.ArticleData.CodingKeys.category)
      self.post = try container.decodeIfPresent(ArticleResponseModel.Post.self, forKey: ArticleResponseModel.ArticleData.CodingKeys.post)
    }
  }

  // MARK: - Post
  public struct Post: Codable {
    let id: Int?
    let postAuthor, postDate, postDateGmt, postContent: String?
    let postTitle, postExcerpt: String?
    let postStatus: String?
    let commentStatus, pingStatus: String?
    let postPassword, postName, toPing: String?
    let pinged: String?
    let postModified, postModifiedGmt, postContentFiltered: String?
    let postParent: Int?
    let guid: String?
    let menuOrder: Int?
    let postType: String?
    let postMIMEType, commentCount: String?
    let filter: String?

    enum CodingKeys: String, CodingKey {
      case id = "ID"
      case postAuthor = "post_author"
      case postDate = "post_date"
      case postDateGmt = "post_date_gmt"
      case postContent = "post_content"
      case postTitle = "post_title"
      case postExcerpt = "post_excerpt"
      case postStatus = "post_status"
      case commentStatus = "comment_status"
      case pingStatus = "ping_status"
      case postPassword = "post_password"
      case postName = "post_name"
      case toPing = "to_ping"
      case pinged
      case postModified = "post_modified"
      case postModifiedGmt = "post_modified_gmt"
      case postContentFiltered = "post_content_filtered"
      case postParent = "post_parent"
      case guid
      case menuOrder = "menu_order"
      case postType = "post_type"
      case postMIMEType = "post_mime_type"
      case commentCount = "comment_count"
      case filter
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<ArticleResponseModel.Post.CodingKeys> = try decoder.container(keyedBy: ArticleResponseModel.Post.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: ArticleResponseModel.Post.CodingKeys.id)
      self.postAuthor = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postAuthor)
      self.postDate = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postDate)
      self.postDateGmt = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postDateGmt)
      self.postContent = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postContent)
      self.postTitle = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postTitle)
      self.postExcerpt = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postExcerpt)
      self.postStatus = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postStatus)
      self.commentStatus = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.commentStatus)
      self.pingStatus = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.pingStatus)
      self.postPassword = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postPassword)
      self.postName = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postName)
      self.toPing = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.toPing)
      self.pinged = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.pinged)
      self.postModified = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postModified)
      self.postModifiedGmt = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postModifiedGmt)
      self.postContentFiltered = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postContentFiltered)
      self.postParent = try container.decodeIfPresent(Int.self, forKey: ArticleResponseModel.Post.CodingKeys.postParent)
      self.guid = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.guid)
      self.menuOrder = try container.decodeIfPresent(Int.self, forKey: ArticleResponseModel.Post.CodingKeys.menuOrder)
      self.postType = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postType)
      self.postMIMEType = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.postMIMEType)
      self.commentCount = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.commentCount)
      self.filter = try container.decodeIfPresent(String.self, forKey: ArticleResponseModel.Post.CodingKeys.filter)
    }

  }

}

