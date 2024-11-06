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
  
  var copyOfCategoryPrices: [PriceCategoryViewModel] = []
  var onSelectPriceCategory: (String) -> Void
  var onSelectCategory: (CategoryViewModel) -> Void
  var onTap: () -> Void
  
  init(
    categoryPrices: [PriceCategoryViewModel],
    onSelectPriceCategory: @escaping (String) -> Void,
    onSelectCategory: @escaping (CategoryViewModel) -> Void,
    onTap: @escaping () -> Void
  ) {
    self.categoryPrices = categoryPrices
    self.onSelectPriceCategory = onSelectPriceCategory
    self.onSelectCategory = onSelectCategory
    self.onTap = onTap
    
    self.copyOfCategoryPrices = categoryPrices
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Text("Pilih Konsultasi")
          .titleLexend(size: 16)
        
        ScrollView(showsIndicators: false) {
          ForEach(categoryPrices) { price in
            NavigationLink {
              ChangeCategoryIssueView(
                issues: price.categories,
                onSelectedCategory: { viewModel in
                  onSelectCategory(viewModel)
                },
                onTap: { _ in
                  onTap()
                }
              )
              .navigationBarBackButtonHidden()
              .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                  HStack {
                    Button {
                      showCategory = false
                      self.categoryPrices = []
                    } label: {
                      Image(systemName: "arrow.backward")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                    }
                    Text("Pilih Kategori")
                      .titleLexend(size: 14)
                  }
                }
              }
            } label: {
              priceContentView(price: price)
                .frame(width: screen.width - 16 - 16)
            }
            .simultaneousGesture(TapGesture().onEnded{ _ in
              onSelectPriceCategory(price.price)
            })
          }
        }
      }
      .onAppear {
        self.categoryPrices = copyOfCategoryPrices
      }
    }
    .navigationTitle("Pilih Kategori")
  }
  
  @ViewBuilder
  func priceContentView(price: PriceCategoryViewModel) -> some View {
    VStack(alignment: .leading) {
      Text(price.title)
        .foregroundColor(Color.darkTextColor)
        .bodyLexend(size: 12)
        .padding(.all, 8)
      
      ChipLayout(models: price.categories) { category in
        ChipTextView(
          text: category.name,
          textColor: .buttonActiveColor,
          backgroundColor: .primary050
        )
      }
      .padding(.horizontal, 8)
      
      HStack {
        
        if price.isProbono {
          probonoPriceView(price: price)
            .padding(.top, 12)
        } else if price.isDiscount {
          discountPriceView(price: price)
            .padding(.top, 12)
        } else {
          normalPriceView(price: price.price)
            .padding(.top, 12)
        }
        
        Spacer()
        
        Image("ic_chevron", bundle: .module)
      }
      .padding(.horizontal, 8)
      .frame(maxWidth: .infinity, minHeight: 50)
      .background(Color.gray050)
    }
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.gray100, lineWidth: 1)
    }
  }
  
  @ViewBuilder
  func discountPriceView(price: PriceCategoryViewModel) -> some View {
    HStack {
      Text(price.price)
        .foregroundColor(Color.buttonActiveColor)
        .bodyLexend(size: 14)
      
      StrikethroughText(
        text: price.originalPrice,
        color: Color.black,
        thickness: 1
      )
      
      DiscountView()
    }
  }
  
  @ViewBuilder
  func normalPriceView(price: String) -> some View {
    HStack {
      Text(price)
        .foregroundColor(Color.buttonActiveColor)
        .titleStyle(size: 14)
      
      Spacer()
      
      Image("ic_next", bundle: .module)
        .resizable()
        .frame(width: 15, height: 18)
    }
  }
  
  @ViewBuilder
  func probonoPriceView(price: PriceCategoryViewModel) -> some View {
    HStack {
      Image("ic_probono", bundle: .module)
      
      Divider()
        .frame(width: 1, height: 10)
        .background(Color.lightGrayBg)
      
      VStack(alignment: .leading) {
        Text(price.price)
          .foregroundColor(Color.buttonActiveColor)
          .titleStyle(size: 14)
          .lineLimit(1)
        
        StrikethroughText(
          text: price.originalPrice,
          color: .lightTextColor,
          thickness: 1
        )
        .foregroundColor(Color.lightTextColor)
      }
      
      Image("ic_next", bundle: .module)
        .resizable()
        .frame(width: 15, height: 18)
    }
  }
}

#Preview {
  PriceCategoryView(
    categoryPrices:
      [
        PriceCategoryViewModel(
          id: 1,
          title: "Kategori Hukum",
          price: "Rp60.000",
          originalPrice: "Rp150.000",
          isDiscount: true,
          isProbono: false,
          categories: [
            CategoryViewModel(
              id: 1,
              name: "Pidana"),
            CategoryViewModel(
              id: 2,
              name: "Perdata"),
            CategoryViewModel(
              id: 3,
              name: "Ketenagakerjaan"),
            CategoryViewModel(
              id: 4,
              name: "Perkawinan & Perceraian"),
            CategoryViewModel(
              id: 5,
              name: "Pidana"
            )
          ]
        ),
        PriceCategoryViewModel(
          id: 2,
          title: "Kategori Hukum",
          price: "Rp60.000",
          originalPrice: "Rp150.000",
          isDiscount: true,
          isProbono: false,
          categories: [
            CategoryViewModel(
              id: 1,
              name: "Ketenagakerjaan"),
            CategoryViewModel(
              id: 2,
              name: "Perkawinan & Perceraian"),
            CategoryViewModel(
              id: 3,
              name: "Pidana"
            )
          ]
        )
      ],
    onSelectPriceCategory: { _ in},
    onSelectCategory: { _ in },
    onTap: {}
  ).padding(.all, 8)
}
