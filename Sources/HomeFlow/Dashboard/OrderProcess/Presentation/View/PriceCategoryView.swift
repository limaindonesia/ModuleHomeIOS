//
//  PriceCategoryView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 04/11/24.
//

import SwiftUI
import AprodhitKit
import GnDKit

struct PriceCategoryView: View {
  
  @State var showCategory: Bool = false
  @State var categoryPrices: [PriceCategoryViewModel]
  var categoryPricesNonSelected: [PriceCategoryViewModel] = []
  var selectedID: Int
  var lawyerInfo: LawyerInfoViewModel
  var onSelectCategory: (Int) -> Void
  
  @State var selectedIndex: Int?
  
  init(
    categoryPrices: [PriceCategoryViewModel],
    categoryPricesNonSelected: [PriceCategoryViewModel],
    selectedID: Int,
    lawyerInfo: LawyerInfoViewModel,
    onSelectCategory: @escaping (Int) -> Void
  ) {
    self.categoryPrices = categoryPrices
    self.categoryPricesNonSelected = categoryPricesNonSelected
    self.selectedID = selectedID
    self.lawyerInfo = lawyerInfo
    self.onSelectCategory = onSelectCategory
    
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        CircleAvatarImageView(
          lawyerInfo.imageURL,
          width: 48,
          height: 48
        )
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.bottom, 8)
        
        Text(lawyerInfo.name)
          .titleLexend(size: 16)
          .padding(.trailing, 16)
          .padding(.bottom, 8)
      }
      .frame(maxWidth: UIScreen.main.bounds.width,alignment: .leading)
      .background(Color.white)
      .padding(.bottom, 8)
      
      VStack {
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading) {
            ForEach(0..<categoryPrices.count, id: \.self) { index in
              VStack(alignment: .leading) {
                HStack {
                  Text(categoryPrices[index].name)
                    .foregroundColor(Color.gray800)
                    .titleLexend(size: 14)
                    .padding(.leading, 12)
                    .padding(.top, 8)
                  
                  Spacer()
                  
                  Image(categoryPrices[index].isSelected ? "ic_order_service_selected" : "ic_order_service_unselect", bundle: .module)
                    .padding(.trailing, 12)
                    .padding(.top, 8)
                  
                }
                
                Text(categoryPrices[index].caseExample)
                  .foregroundColor(Color.gray600)
                  .captionLexend(size: 12)
                  .padding(.leading, 12)
                  .padding(.trailing, 40)
                
                Divider()
                  .background(categoryPrices[index].isSelected ? Color.primaryInfo200 : Color.gray200)
                  .frame(height: 1)
                  .padding(.leading, 12)
                  .padding(.trailing, 40)
                
                HStack {
                  Text("Mulai dari")
                    .foregroundColor(Color.darkGray400)
                    .captionLexend(size: 10)
                    .padding(.leading, 12)
                    .padding(.bottom, 12)
                  
                  Text(categoryPrices[index].price)
                    .foregroundColor(Color.buttonActiveColor)
                    .titleLexend(size: 14)
                    .padding(.bottom, 12)

                }
                
              }
              .onTapGesture {
                categoryPrices = []
                categoryPrices = categoryPricesNonSelected
                categoryPrices[index].isSelected = true
                selectedIndex = index
              }
              .background(categoryPrices[index].isSelected ? Color.primaryInfo050 : Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .overlay {
                RoundedRectangle(cornerRadius: 12)
                  .stroke(categoryPrices[index].isSelected ? Color.primaryInfo200 : Color.gray200, lineWidth: 1)
              }
              .padding(.vertical, 8)
            }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
        }
      }
      
      Spacer()
      
      
      
      VStack(alignment: .leading) {
        Divider()
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        Button {
          onSelectCategory(selectedIndex ?? 0)
        } label: {
          Text("Pilih")
            .foregroundColor(Color.white)
            .titleLexend(size: 12)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.horizontal, 5)
        }
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.buttonActiveColor)
        )
      }
      .padding(.horizontal, 16)
      .edgesIgnoringSafeArea(.all)
      .background(Color.white)
      .frame(maxWidth: .infinity, maxHeight: 44)
    }
    .padding(.horizontal, 16)
    .background(Color.gray050)
  }
  
}

#Preview {
  PriceCategoryView(
    categoryPrices:
      [
        PriceCategoryViewModel(
          id: 1,
          lawyerSkillPriceId: 1,
          skillId: 1,
          name: "lawyer 1",
          caseExample: "abshjdbajhdbaj bdjha bsbdabdabshd bhajsb dabdbajbdjabdjbajdbjas bjdsba bdjas bdjab jdhbajh basj dabdaj adsadadsadasd ",
          price: "90.000",
          originalPrice: "100.000",
          isSelected: false),
        PriceCategoryViewModel(
          id: 2,
          lawyerSkillPriceId: 1,
          skillId: 1,
          name: "lawyer 1",
          caseExample: "abshjdbajhdbaj bdjha bsbdabdabshd bhajsb dabdbajbdjabdjbajdbjas bjdsba bdjas bdjab jdhbajh basj dabdaj asdajndjkasndsjksanjkd njkanjdsk ajkndj kasnjk dnjkasnjkd nakjs dnkjankjdnaksndankdadajns",
          price: "90.000",
          originalPrice: "100.000",
          isSelected: true)
      ],
    categoryPricesNonSelected: [],
    selectedID: 0,
    lawyerInfo: LawyerInfoViewModel(
      id: 0,
      imageURL: nil,
      name: "Lawyer Name",
      agency: "",
      price: "",
      originalPrice: "",
      isDiscount: false,
      isProbono: false,
      orderNumber: "",
      detailIssues: ""),
    onSelectCategory: { _ in }
  )
}
