//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit


struct FilterKemenPPPAContentView: View {
    @State var selectedProvinces: Set<ProvincesList> = []
    @State var selectedCities: Set<CityList> = []
    @State private var searchText = ""

    var allProvinces: [ProvincesList] = []
    var allCities: [CityList] = []
    var isProvinceFilter = false

    var filteredProvinces: [ProvincesList] {
        if searchText.isEmpty {
            return allProvinces
        } else {
            return allProvinces.filter {
              $0.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
    var filteredCities: [CityList] {
        if searchText.isEmpty {
            return allCities
        } else {
            return allCities.filter {
                $0.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
  
    var onApply: (_ provinces: Set<ProvincesList>, _ cities: Set<CityList>) -> Void = { _, _ in }
    var onDismiss: () -> Void = { }

    public init(
        allProvinces: [ProvincesList],
        allCities: [CityList],
        isProvinceFilter: Bool = false,
        onApply: @escaping (_ provinces: Set<ProvincesList>, _ cities: Set<CityList>) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.allProvinces = allProvinces
        self.allCities = allCities
        self.isProvinceFilter = isProvinceFilter
        self.onApply = onApply
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: 16) {

            HStack {
               Text(isProvinceFilter ? "Pilih Provinsi" : "Pilih Kota")
                .titleLexend(size: 20)
                .foregroundStyle(Color.gray900)

                Spacer()
              
              Text("Reset Filter")
                .font(Font(UIFont.lexendFont(style: .caption(size: 12))))
                .foregroundStyle(selectedCities.count > 0 ? Color.primaryInfo700 : Color.gray300)
                .onTapGesture {
                  if !isProvinceFilter {
                    selectedCities.removeAll()
                    searchText = ""
                  }
                }
            }
            .padding(.horizontal)

          TextField(isProvinceFilter ? "Ketik nama provinsi, misalnya: Banten" : "Ketik nama kota dalam provinsi", text: $searchText)
              .padding(12)
              .background(Color.gray050)
              .cornerRadius(8)
              .overlay {
                  RoundedRectangle(cornerRadius: 8)
                      .stroke(Color.gray200, lineWidth: 1)
              }
              .captionLexend(size: 16)
              .padding(.horizontal, 16)
              .frame(maxWidth: .infinity, alignment: .leading)


          ScrollView(showsIndicators: true) {
              VStack(alignment: .leading, spacing: 16) {
                  if isProvinceFilter {
                      ForEach(filteredProvinces, id: \.self) { item in
                          Button(action: {
                              selectedProvinces.insert(item)
                              onApply(selectedProvinces, selectedCities)
                          }) {
                              HStack {
                                  Text(item.name ?? "")
                                      .foregroundColor(Color.gray700)
                                      .captionLexend(size: 14)
                              }
                          }
                          .padding(.horizontal)
                      }
                  } else {
                      ForEach(filteredCities, id: \.self) { item in
                          Button(action: {
                              if selectedCities.contains(item) {
                                  selectedCities.remove(item)
                              } else {
                                  selectedCities.insert(item)
                              }
                          }) {
                              let isSelected = selectedCities.contains(item)
                              let iconName = isSelected ? "checkmark.square.fill" : "square"
                              let iconColor: Color = isSelected ? Color.primary500 : .gray

                              HStack {
                                  Image(systemName: iconName)
                                      .foregroundStyle(iconColor)

                                  Text(item.name ?? "")
                                      .foregroundColor(.black)
                                  Spacer()
                              }
                          }
                          .padding(.horizontal)
                      }
                  }
              }
              .padding(.top, 4)
              .padding(.horizontal, 10)
              .frame(maxWidth: .infinity, alignment: .leading)
          }


          if !isProvinceFilter {
            HStack(spacing: 12) {
              Button("Tutup") {
                onDismiss()
              }
              .font(Font(UIFont.lexendFont(style: .title(size: 14))))
              .frame(maxWidth: .infinity)
              .frame(height: 44)
              .background(Color.white)
              .cornerRadius(12)
              .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
              .foregroundStyle(.black)
              
              Button("Terapkan") {
                onApply(selectedProvinces, selectedCities)
              }
              .font(Font(UIFont.lexendFont(style: .title(size: 14))))
              .frame(maxWidth: .infinity)
              .frame(height: 44)
              .background(selectedCities.count > 0 ? Color.primaryInfo700 : Color.gray100)
              .cornerRadius(12)
              .foregroundStyle(selectedCities.count > 0 ? Color.white : Color.gray300)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
          }

        }
        .frame(height: 508)
        .background(Color.white)
        .cornerRadius(20)
        .ignoresSafeArea(edges: .bottom)
    }
}
