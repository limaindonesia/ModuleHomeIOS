//
//  PromotionBannerView.swift
//
//
//  Created by Ilham Prabawa on 18/10/24.
//

import SwiftUI
import Kingfisher

public struct PromotionBannerView: View {
  
  private let imageURL: URL?
  private var onTapProbono: () -> Void
  private var onTapConsult: () -> Void
  private var onTapBlog: () -> Void
  private var onTapClose: () -> Void
  
  public init(
    imageURL: URL?,
    onTapProbono: @escaping () -> Void,
    onTapConsult: @escaping () -> Void,
    onTapBlog: @escaping () -> Void,
    onTapClose: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.onTapProbono = onTapProbono
    self.onTapConsult = onTapConsult
    self.onTapBlog = onTapBlog
    self.onTapClose = onTapClose
  }
  
  public var oldbody: some View {
    VStack {
      KFImage(imageURL)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, idealHeight: 400)
        .padding(.horizontal, 32)
        .onTapGesture {
          onTapConsult()
        }
      
      Image("system_message_banner_app_close", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 35, height: 35)
        .onTapGesture {
          onTapClose()
        }
    }
  }
  
  public var body: some View {
    
    VStack {
      
      Image("system_message_banner_app_background", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, idealHeight: 400)
        .overlay(
          VStack(spacing: 0) {
            Image("system_message_banner_app_value", bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 350)
              .onTapGesture {
                onTapConsult()
              }
            
            Image("system_message_banner_app_probono", bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .padding(.top, -32)
              .onTapGesture {
                onTapProbono()
              }
          }
            .padding(.top, 12)
            .padding(.horizontal, 8)
        )
        .padding(.horizontal, 32)
        .onTapGesture {
          onTapBlog()
        }
      
      Image("system_message_banner_app_close", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 35, height: 35)
        .onTapGesture {
          onTapClose()
        }
    }
  }
  
}

#Preview {
  PromotionBannerView(imageURL: nil) {
    
  } onTapConsult: {
    
  } onTapBlog: {
    
  } onTapClose: {
    
  }
  
}
