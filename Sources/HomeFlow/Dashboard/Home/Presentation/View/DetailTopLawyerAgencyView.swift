//
//  DetailTopLawyerAgencyView.swift
//
//
//  Created by Ilham Prabawa on 03/10/24.
//

import SwiftUI
import AprodhitKit

public struct DetailTopLawyerAgencyView: View {

  @State var isLoading: Bool = false

  public var body: some View {

    if isLoading {
      ProgressView()
    } else {
      contentView()
    }
  }

  @ViewBuilder
  func contentView() -> some View {
    VStack {

      Image(systemName: "playstation.logo")
        .resizable()
        .frame(width: 64, height: 64)

      Text("Periode: Agustus")
        .foregroundColor(Color.primary500)
        .titleStyle(size: 14)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.primary050)
        .cornerRadius(4)

      ScrollView {

        VStack {

          topAdvocates(
            [
              TopAdvocateViewModel(
                position: 1,
                id: 1,
                image: "",
                name: "",
                agency: "",
                experience: 0
              ),
              TopAdvocateViewModel(
                position: 2,
                id: 2,
                image: "",
                name: "",
                agency: "",
                experience: 0
              ),
              TopAdvocateViewModel(
                position: 3,
                id: 3,
                image: "",
                name: "",
                agency: "",
                experience: 0
              ),
              TopAdvocateViewModel(
                position: 4,
                id: 4,
                image: "",
                name: "",
                agency: "",
                experience: 0
              ),
              TopAdvocateViewModel(
                position: 5,
                id: 5,
                image: "",
                name: "",
                agency: "", experience: 0
              ),
              TopAdvocateViewModel(
                position: 6,
                id: 6,
                image: "",
                name: "",
                agency: "",
                experience: 0
              ),
              TopAdvocateViewModel(
                position: 7,
                id: 7,
                image: "",
                name: "",
                agency: "",
                experience: 0
              )
            ]
          )
          .padding(.bottom, 16)

          topAgencies(
            [
              TopAgencyViewModel(
                position: 1,
                name: "",
                location: ""
              ),
              TopAgencyViewModel(
                position: 2,
                name: "",
                location: ""
              ),
              TopAgencyViewModel(
                position: 3,
                name: "",
                location: ""
              ),
            ]
          )

        }
      }

    }
  }

  @ViewBuilder
  func topAdvocates(_ items: [TopAdvocateViewModel]) -> some View {

    VStack(alignment: .leading) {

      Text("Top Advokat")
        .titleStyle(size: 20)
        .padding(.leading, 16)
        .padding(.bottom, 8)

      ForEach(items, id: \.id) { item in
        VStack(spacing: 0) {
          TopAdvocateRowView(
            imageName: item.getImageURL(),
            title: item.name,
            description: item.agency,
            ranking: item.position
          )
          .frame(maxWidth: .infinity, minHeight: 76)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.horizontal, 16)
        }
      }

    }
    .padding(.vertical, 12)
    .background(Color.primary050)

  }

  @ViewBuilder
  func topAgencies(_ items: [TopAgencyViewModel]) -> some View {

    VStack(alignment: .leading) {

      Text("Top Instansi")
        .titleStyle(size: 20)
        .padding(.leading, 16)
        .padding(.bottom, 8)

      ForEach(items, id: \.position) { item in
        VStack(spacing: 0) {
          TopAgencyRowView(
            imageName: item.getIconName(by: item.position),
            title: item.getName(),
            ranking: item.position
          )
          .frame(maxWidth: .infinity, minHeight: 76)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.horizontal, 16)

          Divider().frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.horizontal, 12)
        }
      }

    }

  }

}

#Preview {
  DetailTopLawyerAgencyView()
}
