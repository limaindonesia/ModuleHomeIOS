//
//  ChangeCategoryIssueView.swift
//
//
//  Created by Ilham Prabawa on 24/10/24.
//

import SwiftUI
import AprodhitKit

struct ChangeCategoryIssueView: View {

  @State private var issues: [CategoryViewModel]
  private let selectedID: Int?
  private var onSelectedCategory: (CategoryViewModel) -> Void
  private var onTap: (CategoryViewModel) -> Void

  @State var selectedIndex: Int?

  init(
    issues: [CategoryViewModel],
    selectedID: Int? = nil,
    onSelectedCategory: @escaping (CategoryViewModel) -> Void,
    onTap: @escaping (CategoryViewModel) -> Void
  ) {
    self.issues = issues
    self.selectedID = selectedID
    self.onSelectedCategory = onSelectedCategory
    self.onTap = onTap
  }

  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading) {
          ForEach(0..<issues.count, id: \.self) { index in
            checkBoxRow(index) { selectedIndex in
              if let i = selectedIndex {
                onSelectedCategory(issues[i])
              }
            }
            .padding(.vertical, 8)
          }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
      }
      .onAppear {
        selectedIndex = issues.firstIndex{ $0.id == selectedID }
      }
      
      PositiveButton(title: "Pilih Kategori") {
        onTap(issues[selectedIndex ?? 0])
      }
      .frame(height: 40)
    }
  }

  @ViewBuilder
  func checkBoxRow(
    _ index: Int,
    onSelected: @escaping (Int?) -> Void
  ) -> some View {
    CheckBoxView(
      text: issues[index].name,
      isChecked: selectedIndex == index
    ) {
      selectedIndex = index
      onSelected(selectedIndex)
    }
  }
}
//
//#Preview {
//  ChangeCategoryIssueView(
//    issues: [
//      CategoryViewModel(id: 1, name: "Perdata"),
//      CategoryViewModel(id: 2, name: "Pertanahan"),
//      CategoryViewModel(id: 3, name: "Ketenagakerjaan"),
//      CategoryViewModel(id: 4, name: "Perkawaninan dan Perceraian")
//    ],
//    selectedID: 1
//  ) { _ in } onTap: { _ in }
//}


