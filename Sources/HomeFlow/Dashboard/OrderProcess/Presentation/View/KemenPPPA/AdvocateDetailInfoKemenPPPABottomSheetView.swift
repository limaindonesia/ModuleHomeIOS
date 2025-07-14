//
//  AdvocateDetailInfoKemenPPPABottomSheetView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 10/07/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct AdvocateDetailInfoKemenPPPABottomSheetView: View {
  
  private let lawyer: Advocate
  private let reviews: LawyerReviewList
  private let totalReview: Int
  private var showMore: () -> Void
  
  public init(
    lawyer: Advocate,
    reviews: LawyerReviewList,
    totalReview: Int,
    showMore: @escaping() -> Void
  ) {
    self.lawyer = lawyer
    self.reviews = reviews
    self.totalReview = totalReview
    self.showMore = showMore
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 16) {
        HStack(alignment: .top, spacing: 8) {
          RoundedImageView(
            imageURL: lawyer.getImageName(),
            width: 80,
            height: 120
          )
          
          VStack(alignment: .leading, spacing: 8) {
            Text(lawyer.name ?? "")
              .lineLimit(2)
              .titleLexend(size: 18)
            
            Text(lawyer.agency_name ?? "")
              .captionLexend(size: 12)
            
            HStack {
              Image("location", bundle: .module)
                .resizable()
                .frame(width: 12, height: 12)
              
              Text(lawyer.getLocation())
                .foregroundColor(.darkGray400)
                .bodyLexend(size: 12)
            }
            .padding(.top, 8)
            
            HStack {
              Image("briefcase", bundle: .module)
                .resizable()
                .frame(width: 12, height: 12)
              
              Text(lawyer.getExperience())
                .foregroundColor(.primaryInfo600)
                .bodyLexend(size: 12)
            }
          }
        }
        .padding(.horizontal, 16)
        
        Divider()
          .background(Color.gray200)
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        VStack(alignment: .leading, spacing: 8) {
          Text("Pendidikan Terakhir")
            .titleLexend(size: 14)
          
          Text(lawyer.getLastEducation())
            .captionLexend(size: 12)
        }
        .padding(.horizontal, 16)
        
        Divider()
          .background(Color.gray200)
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        VStack(alignment: .leading, spacing: 8) {
          Text("Tentang Advokat")
            .titleLexend(size: 14)
          
          Text(lawyer.description ?? " - ")
            .captionLexend(size: 12)
        }
        .padding(.horizontal, 16)
        
        Divider()
          .background(Color.gray200)
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        HStack {
          Text("Ulasan (\(totalReview))")
            .titleLexend(size: 16)
          
          Spacer()
          
          Button {
            showMore()
          } label: {
            Text("Lihat Semua")
              .foregroundStyle(Color.buttonActiveColor)
              .titleLexend(size: 12)
          }
          
        }
        .padding(.horizontal, 16)
        
        LazyVStack(spacing: 16) {
          ForEach(reviews.data, id: \.self) { model in
            reviewRowView(model: model)
          }
        }
        .padding(.horizontal, 16)
      }
      .padding(.top, 16)
    }
  }
  
  @ViewBuilder
  func reviewRowView(model: LawyerReviewListData) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      
      HStack {
        RatingView(rating: model.rating ?? "")
        
        Spacer()
        
        Text(model.getSentAt())
          .bodyLexend(size: 12)
      }
      
      LabelView(
        title: model.skill ?? "",
        textColor: Color.gray500,
        radius: 12
      )
      
      Text(model.name ?? "")
        .titleLexend(size: 12)
      
      Text(model.description ?? "")
        .captionLexend(size: 12)
    }
    .padding(.all, 8)
    .background(Color.gray050)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    
  }
  
}

extension AdvocateDetailInfoKemenPPPABottomSheetView {
  
  func getSkills() -> [String] {
    let names = lawyer.detail
      .compactMap { $0! }
      .map { $0.name ?? "" }
    
    return names
  }
  
}

#Preview {
  AdvocateDetailInfoBottomSheetView(
    lawyer: .init(),
    reviews: .init(),
    totalReview: 0,
    showMore: {}
  )
}
