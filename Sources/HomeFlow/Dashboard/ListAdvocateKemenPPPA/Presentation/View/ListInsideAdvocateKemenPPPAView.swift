//
//  ListAdvocateKemenPPAListView.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//


import SwiftUI
import GnDKit
import Kingfisher
import AprodhitKit

public struct ListInsideAdvocateKemenPPPAView: View {
  
  private let name: String
  private let imageName: URL?
  private let location: String
  private let experience: String
  private let rating: String
  private let totalConsultation: Int
  private let isOnline: Bool
  private let isBusy: Bool
  private let isAlreadyPressNotif: Bool
  private var onTap: () -> Void
  private var onTapConsultation: () -> Void
  
  public init(
    name: String,
    imageName: URL?,
    location: String,
    experience: String,
    rating: String,
    totalConsultation: Int,
    isOnline: Bool,
    isBusy: Bool,
    isAlreadyPressNotif: Bool,
    onTap: @escaping () -> Void,
    onTapConsultation: @escaping () -> Void
  ) {
    self.name = name
    self.imageName = imageName
    self.location = location
    self.experience = experience
    self.rating = rating
    self.totalConsultation = totalConsultation
    self.isOnline = isOnline
    self.isBusy = isBusy
    self.isAlreadyPressNotif = isAlreadyPressNotif
    self.onTap = onTap
    self.onTapConsultation = onTapConsultation
  }
  
  public var body: some View {
    ZStack(alignment: .topTrailing) {
      
      ZStack(alignment: .topTrailing) {
        
        ZStack(alignment: .topTrailing) {
          
          VStack(alignment: .leading) {
            
            HStack(alignment: .top, spacing: 0) {
              
              ZStack(alignment: .topTrailing) {
                
                GeometryReader { proxy in
                  let frame = proxy.frame(in: .local)
                  
                  RoundedAvatarImageView(
                    imageName,
                    width: 56,
                    height: 84
                  )
                  .padding(.bottom, 12)
                  
                  AdvocateAvailableView(radius: 6)
                    .position(x: frame.midX, y: frame.maxY - 8)
                  
                  Circle()
                    .fill(isOnline ? Color.success100 : Color.gray200)
                    .frame(width: 14, height: 14)
                    .overlay {
                      Circle()
                        .fill(isOnline ? Color.success500 : Color.gray300)
                        .frame(width: 9, height: 9)
                    }
                    .padding(.top, -4)
                    .padding(.leading, -4)
                }
                
              }
              .frame(width: 60, height: 84)
              .padding(.horizontal, 12)
              
              VStack(alignment: .leading, spacing: 4) {
                Text(name)
                  .foregroundColor(Color.darkTextColor)
                  .titleStyle(size: 14)
                  .padding(.bottom, 8)
                  .padding(.top, 8)
                
                HStack(spacing: 8) {
                  if !location.isEmpty {
                    HStack(alignment: .center, spacing: 2) {
                      Image("location", bundle: .module)
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color(hex: 0xFEAF27))
                      
                      Text(location)
                        .foregroundColor(Color.darkTextColor)
                        .captionStyle(size: 12)
                    }
                  }
                  
                  HStack(alignment: .center, spacing: 2) {
                    Image("medal-star", bundle: .module)
                      .resizable()
                      .frame(width: 12, height: 12)
                      .foregroundColor(Color(hex: 0xFEAF27))
                    
                    Text("Terverifikasi oleh Peradi")
                      .foregroundColor(Color.primaryInfo600)
                      .captionStyle(size: 12)
                  }
                }
                
                HStack(alignment: .center, spacing: 8) {
                  HStack(spacing: 4) {
                    Image("briefcase", bundle: .module)
                    
                    Text(experience)
                      .foregroundColor(Color.darkTextColor)
                      .captionStyle(size: 12)
                  }
                  
                  if totalConsultation > 0 {
                    Divider()
                      .frame(width: 1, height: 10)
                      .background(Color.lightGrayBg)
                    
                    HStack(spacing: 4) {
                      Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color(hex: 0xFEAF27))
                      
                      Text(rating)
                        .foregroundColor(Color.darkTextColor)
                        .captionStyle(size: 12)
                      
                      Text("(\(totalConsultation) Konsultasi)")
                        .foregroundColor(Color.darkTextColor)
                        .captionStyle(size: 12)
                    }
                  }
                }
              }
              .padding(.trailing, 8)
            }
            .background(Color.white)
            
            Divider()
              .frame(maxWidth: .infinity, maxHeight: 1)
              .padding(.top, 8)
            
            bottomView {
              onTapConsultation()
            }
            .padding(.top, 4)
            .padding(.horizontal, 8)
              
            
          }
        }
        .padding(.vertical, 8)
        .frame(
          maxWidth: .infinity,
          maxHeight: 285,
          alignment: .leading
        )
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.lightGrayBg))
        .onTapGesture { onTap() }
      }.padding(.top, 10)
      .frame(
        maxWidth: .infinity,
        maxHeight: 300,
        alignment: .leading
      )
      .background(Color.clear)
    }
    
  }
  
  
  @ViewBuilder
  func bottomView(
    onTapConsultation: @escaping () -> Void) -> some View {
    HStack {
      Text("Gratis")
        .foregroundColor(Color.buttonActiveColor)
        .titleStyle(size: 14)
      
      Spacer()
      
      Image(isBusy ? "ic_consultation_isbusy" : isOnline ? "ic_consultation_online" : isAlreadyPressNotif ? "ic_consultation_notif_on" : "ic_consultation_notif_off", bundle: .module)
        .scaledToFit()
        .frame(width: isBusy ? 100 : isOnline ? 87 : isAlreadyPressNotif ? 135 : 158, height: 32)
        .onTapGesture {
          onTapConsultation()
        }
    }
    .background(.white)
  }
}
