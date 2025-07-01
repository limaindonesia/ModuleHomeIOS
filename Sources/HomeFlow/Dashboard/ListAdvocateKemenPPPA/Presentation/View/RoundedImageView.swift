//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//

import SwiftUI
import Kingfisher
import GnDKit

public struct RoundedImageView: View {
  
  private let imageURL: URL?
  private let width: CGFloat?
  private let height: CGFloat?
  
  public init(imageURL: URL?) {
    self.imageURL = imageURL
    self.width = 10
    self.height = 10
  }
  
  public init(
    imageURL: URL?,
    width: CGFloat? = 48,
    height: CGFloat? = 48
  ) {
    self.imageURL = imageURL
    self.width = width
    self.height = height
  }
  
  public var body: some View {
    KFImage(imageURL)
      .placeholder{
        Image("ic_placeholder_img", bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
      }
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(
        width: width,
        height: height
      )
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.gray200, lineWidth: 1)
      }
  }
  
}

struct RoundedImageView_Previews: PreviewProvider {
  static var previews: some View {
    RoundedImageView(imageURL: nil, width: 48, height: 48)
  }
}
