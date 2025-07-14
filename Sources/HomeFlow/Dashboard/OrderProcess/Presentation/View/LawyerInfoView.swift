//
//  LawyerInfoView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 16/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct LawyerInfoView: View {
  
  let imageURL: URL?
  let name: String
  let agency: String
  let price: String
  let originalPrice: String
  let isDiscount: Bool
  let isProbono: Bool
  let timeStr: String
  let experience: String
  let rating: String
  let totalConsultation: String
  var onTap: () -> Void
  
  init(
    imageURL: URL?,
    name: String,
    agency: String,
    price: String,
    originalPrice: String,
    isDiscount: Bool,
    isProbono: Bool,
    timeStr: String,
    experience: String,
    rating: String,
    totalConsultation: String,
    onTap: @escaping () -> Void
  ) {
    self.imageURL = imageURL
    self.name = name
    self.agency = agency
    self.price = price
    self.originalPrice = originalPrice
    self.isDiscount = isDiscount
    self.isProbono = isProbono
    self.timeStr = timeStr
    self.experience = experience
    self.rating = rating
    self.totalConsultation = totalConsultation
    self.onTap = onTap
  }
  
  var body: some View {
    HStack (spacing: 12) {
      CircleAvatarImageView(
        imageURL,
        width: 48,
        height: 48
      )
      .padding(.leading, 16)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(name)
          .titleLexend(size: 14)
        
        HStack {
          Image("briefcase", bundle: .module)
          
          Text(experience)
            .foregroundColor(.darkGray400)
            .bodyLexend(size: 12)
          
          Image("ic_vector", bundle: .module)
          
          Image("ic_star", bundle: .module)
            .resizable()
            .frame(width: 10, height: 10)
          
          Text(rating)
            .foregroundColor(.darkGray400)
            .bodyLexend(size: 12)
          
          Text(totalConsultation)
            .foregroundColor(.darkGray300)
            .bodyLexend(size: 10)
          
        }
        
      }
      .padding(.top, 16)
      .padding(.bottom, 16)
      
      Spacer()
      
      Image("ic_chevron_down", bundle: .module)
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.trailing, 8)
    }
    .frame(maxWidth: .infinity, maxHeight: 80)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .gray200, radius: 8)
    .onTapGesture {
      onTap()
    }
  }
}

#Preview {
  LawyerInfoView(
    imageURL: nil,
    name: "",
    agency: "",
    price: "",
    originalPrice: "",
    isDiscount: false,
    isProbono: false,
    timeStr: "",
    experience: "",
    rating: "",
    totalConsultation: "",
    onTap: {}
  )
}
