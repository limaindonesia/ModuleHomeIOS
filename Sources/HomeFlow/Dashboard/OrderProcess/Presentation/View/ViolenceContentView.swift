//
//  ViolenceContentView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 17/06/25.
//

import SwiftUI
import GnDKit

public struct ViolenceContentView: View {
  
  //dependency
  private let violences: [ViolenceCategoryEntity]
  @Binding private var isPresent: Bool
  
  @State private var selected: ViolenceCategoryEntity?
  private var onSelect: (ViolenceCategoryEntity?) -> Void
  
  public init(
    violences: [ViolenceCategoryEntity],
    isPresent: Binding<Bool>,
    onSelect: @escaping (ViolenceCategoryEntity?) -> Void
  ) {
    self.violences = violences
    self._isPresent = isPresent
    self.onSelect = onSelect
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Pilih Kategori Hukum")
          .titleLexend(size: 14)
        
        Spacer()
        
        Button {
          isPresent = false
        } label: {
          Image(systemName: "xmark")
            .foregroundStyle(Color.black)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 4)
      .padding(.horizontal, 16)
      
      ScrollView {
        ForEach(violences) { violence in
          violenceRowView(violence: violence)
        }
        .padding(.vertical)
      }
      .background(Color.gray050)
      
      ButtonPrimary(
        title: "Pilih",
        color: .buttonActiveColor,
        width: .infinity,
        height: 40,
        isActive: selected != nil
      ) {
        isPresent = false
        onSelect(selected)
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 16)
    }
  }
  
  @ViewBuilder
  func violenceRowView(violence: ViolenceCategoryEntity) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .top) {
        Text(violence.title)
          .titleLexend(size: 14)
        
        Spacer()
        
        RadioButtonView(
          label: "",
          isSelected: selected == violence
        ) {
          selected = violence
        }
      }
      
      Text(violence.description)
        .foregroundStyle(Color.gray600)
        .captionLexend(size: 12)
        .padding(.trailing, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.leading, 16)
    .padding(.vertical, 16)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.gray200, lineWidth: 1)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 3)
    .onTapGesture {
      selected = violence
    }
    
  }
  
}

#Preview {
  ViolenceContentView(
    violences: [],
    isPresent: .constant(true)
  ) { _ in
    
  }
}
