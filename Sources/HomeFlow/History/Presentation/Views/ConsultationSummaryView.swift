//
//  ConsultationSummaryView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 20/06/25.
//

import SwiftUI
import AprodhitKit
import GnDKit

public struct ConsultationSummaryView: View {
  
  public var userCases: UserCases
  public var onTapShowChat: ((UserCases, Int, String) -> Void)?
  public var onTapReview: ((UserCases) -> Void)?
  public var onSeeNumber: (() -> Void)?
  
  @State private var wouldOverflow: Bool = false
  
  public init(
    userCases: UserCases,
    onTapShowChat: (@escaping ((UserCases, Int, String) -> Void)),
    onTapReview: (@escaping (UserCases) -> Void),
    onSeeNumber: (@escaping () -> Void)
  ) {
    self.userCases = userCases
    self.onTapShowChat = onTapShowChat
    self.onTapReview = onTapReview
    self.onSeeNumber = onSeeNumber
  }
  
  public var body: some View {
    if isSummaryHasBeenSent {
      ScrollView(showsIndicators: false) {
        successView()
          .padding(.top, 16)
      }
    } else {
      waitingForSummaryView()
    }
  }
  
  @ViewBuilder
  func successView() -> some View {
    VStack(spacing: 12) {
      
      historyView()
      
      if userCases.service_type == Constant.Text.KEMENPPPA {
        kemenPPPABannerView()
        
        kemenPPPACategoryView()
        
      } else {
        categoryView()
      }
      
      if isRatingEmpty() {
        HStack {
          Image("like", bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
          
          Text("Anda belum menilai Advokat, ulasan Anda bantu klien lain.")
            .captionLexend(size: 12)
          
          Spacer()
          
          Button {
            onTapReview?(userCases)
          } label: {
            Text("Beri Penilaian")
              .foregroundStyle(Color.buttonActiveColor)
              .titleLexend(size: 14)
          }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryInfo050)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.primaryInfo200)
        }
        .padding(.horizontal, 16)
      }
      
      if !editedDate.isEmpty {
        Text("Terakhir diperbarui : \(editedDate)")
          .captionLexend(size: 12)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.horizontal, 16)
          .padding(.top, 12)
      }
      
      VStack(alignment: .leading, spacing: 12) {
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Duduk Perkara")
            .titleLexend(size: 14)
          
          Text(userCases.summary?.matter ?? "")
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
        }
        
        Divider()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundStyle(Color.gray100)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Dasar Hukum")
            .titleLexend(size: 14)
          
          Text(userCases.summary?.legal_basis ?? "")
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
        }
        
        Divider()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundStyle(Color.gray100)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Analisis")
            .titleLexend(size: 14)
          
          Text(userCases.summary?.analysis ?? "")
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
        }
        
        Divider()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundStyle(Color.gray100)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Kesimpulan & Saran")
            .titleLexend(size: 14)
          
          Text(userCases.summary?.conclusion ?? "")
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
        }
        
        if userCases.summary?.is_allowed_show_advocate_phone ?? false == true {
          VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
              VStack(alignment: .leading) {
                Text("Perlu Nomor Telp Advokat?")
                  .titleLexend(size: 14)
                  .foregroundColor(Color.gray700)
                
                Spacer()
                
                Text("Hubungi advokat langsung jika butuh pendampingan.")
                  .captionLexend(size: 12)
                  .foregroundColor(Color.gray800)
                  .lineLimit(nil)
              }
              
              Spacer()
              
              Text("Lihat Nomor")
                .font(Font(UIFont.lexendFont(style: .title(size: 12))))
                .foregroundColor(Color.primaryInfo700)
                .padding(.leading, 8)
                .onTapGesture {
                  onSeeNumber?()
                }
            }
            
            
          }
          .padding(16)
          .background(Color.gray050)
          .cornerRadius(8)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray200, lineWidth: 1)
          )
        }
        
        LineShape()
          .stroke(Color.gray200, style: StrokeStyle(lineWidth: 1, lineJoin: .round, dash: [10, 5]))
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        Text("Salinan transkrip dan ringkasan konsultasi dikirim ke WhatsApp dan email yang terdaftar di Perqara.")
          .foregroundStyle(Color.gray500)
          .captionLexend(size: 12)
        
        VStack {
          Text("Ringkasan diatas hanya sebatas pendapat hukum yang diberikan oleh Advokat berdasarkan data dan informasi yang disampaikan oleh klien pada saat konsultasi. Perqara tidak bertanggung jawab atas pemberian dan pelaksanaan lebih lanjut terkait dengan pendapat hukum tersebut.")
            .foregroundStyle(Color.gray800)
            .captionLexend(size: 12)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.gray050)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
        }
        
      }
      .padding(.horizontal, 16)
    }
  }
  
  @ViewBuilder
  func categoryEdited() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Kategori Konsultasi:")
        .foregroundStyle(Color.darkTextColor)
        .bodyLexend(size: 12)
      
      TextOverflowDetector(
        text1: oldIssue,
        text2: issue,
        fontSize: 10,
        fontWeight: .regular,
        onAppear: { overflow in
          wouldOverflow = overflow
        }
      )
      
      if wouldOverflow {
        VStack(alignment: .leading) {
          HStack {
            LabelStrikeThroughView(
              text: oldIssue,
              textColor: Color.pink,
              color: .gray100
            )
            
            Circle()
              .fill(Color.gray100)
              .frame(width: 24, height: 24)
              .overlay {
                Image("arrow-right", bundle: .module)
                  .resizable()
                  .frame(width: 20, height: 20)
              }
          }
          
          LabelView(
            title: issue,
            textColor: Color.primary700,
            radius: 12
          )
          
          LabelView(
            title: subIssue,
            textColor: Color.gray500,
            radius: 12
          )
        }
        .padding(.bottom, 8)
        
      } else {
        VStack(alignment: .leading) {
          HStack {
            LabelStrikeThroughView(
              text: oldIssue,
              textColor: Color.pink,
              color: .gray050
            )
            
            Circle()
              .fill(Color.gray100)
              .frame(width: 24, height: 24)
              .overlay {
                Image("arrow-right", bundle: .module)
                  .resizable()
                  .frame(width: 20, height: 20)
              }
            
            LabelView(
              title: issue,
              textColor: Color.primary700,
              radius: 12
            )
          }
          
          LabelView(
            title: subIssue,
            textColor: Color.gray500,
            radius: 12
          )
        }
        .padding(.bottom, 8)
      }
      
      LineShape()
        .stroke(Color.gray200, style: StrokeStyle(lineWidth: 1, lineJoin: .round, dash: [10, 5]))
        .frame(maxWidth: .infinity, maxHeight: 1)
      
      Text("Advokat telah mengubah kategori konsultasi")
        .captionLexend(size: 12)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 8)
    .background(Color.white)
    .frame(maxWidth: .infinity, alignment: .leading)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func chatHistoryView() -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Chat Tersedia dalam 24 jam")
          .foregroundStyle(Color.buttonActiveColor)
          .titleLexend(size: 14)
        
        Text("Chat konsultasi dapat dibaca kembali hingga \(getExpiredDaysHoursStop())")
          .captionLexend(size: 12)
      }
      
      Spacer()
      
      Button {
        navigateToChat(
          userCases,
          clientID: userCases.client?.id ?? 0,
          clientName: userCases.client?.name ?? ""
        )
      } label: {
        Text("Lihat Chat")
          .foregroundStyle(Color.buttonActiveColor)
          .titleLexend(size: 14)
      }
      
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.primaryInfo050)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(Color.primaryInfo200)
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func chatHiddenInfo() -> some View {
    HStack(alignment: .top) {
      Text("Demi keamanan privasi, chat konsultasi otomatis terhapus setelah 24 jam sesi selesai.")
        .foregroundStyle(Color.warning800)
        .captionLexend(size: 12)
      
      Spacer()
      
      Button {
        
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(Color.warning800)
      }
      
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.warning050)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(Color.warning600)
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func waitingForSummaryView() -> some View {
    VStack(alignment: .center, spacing: 8) {
      Image("sand", bundle: .module)
        .padding(.bottom, 16)
      
      Text("Menunggu Ringkasan Konsultasi")
        .titleLexend(size: 20)
      
      Text("Advokat sedang menyiapkan ringkasan konsultasi. Anda akan mendapatkan notifikasi setelah tersedia.")
        .captionLexend(size: 16)
        .multilineTextAlignment(.center)
    }
  }
  
  @ViewBuilder
  func categoryView() ->  some View {
    if isSkillHasEdited {
      categoryEdited()
    } else {
      VStack(alignment: .leading, spacing: 12) {
        Text("Kategori Konsultasi:")
          .foregroundStyle(Color.darkTextColor)
          .bodyLexend(size: 12)
        
        HStack(spacing: 8) {
          LabelView(
            title: issue,
            textColor: Color.primaryInfo600,
            radius: 12
          )
          
          if didHaveSubIssue {
            LabelView(
              title: subIssue,
              textColor: Color.gray500,
              radius: 12
            )
          }
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 8)
      .background(Color.white)
      .frame(maxWidth: .infinity, alignment: .leading)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
      }
      .padding(.horizontal, 16)
    }
  }
  
  @ViewBuilder
  func historyView() -> some View {
    if showHistoryChat() {
      chatHistoryView()
    } else {
      chatHiddenInfo()
    }
  }
  
  @ViewBuilder
  func kemenPPPABannerView() -> some View {
    VStack(alignment: .leading, spacing: 4) {
      
      Image("kemenpppa_perqara", bundle: .module)
        .padding(.top, 8)
      
      Text("Bantuan hukum perlindungan perempuan & anak, kerja sama KemenPPPA RI & Peradi")
        .lineLimit(2)
        .captionLexend(size: 12)
      
      LineShape()
        .stroke(Color.primaryInfo200, style: StrokeStyle(lineWidth: 1, lineJoin: .round, dash: [10, 5]))
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(.top, 8)
      
      Text("Saran Langkah Lanjutan dari Advokat")
        .titleLexend(size: 14)
        .padding(.vertical, 4)
      
      VStack(alignment: .leading, spacing: 3) {
        ForEach(getRecommendations(), id: \.self) { point in
          HStack(alignment: .center, spacing: 8) {
            Text("•")
              .bodyLexend(size: 16)
            Text(point)
              .captionLexend(size: 12)
          }
        }
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
    .background(Color.primaryInfo050)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8).stroke(Color.primaryInfo200)
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  func kemenPPPACategoryView() -> some View {
    VStack {
      VStack(alignment: .leading, spacing: 8) {
        Text("Kategori Konsultasi:")
          .foregroundStyle(Color.darkTextColor)
          .bodyLexend(size: 12)
        
        TextOverflowDetector(
          text1: oldIssue,
          text2: issue,
          fontSize: 10,
          fontWeight: .regular,
          onAppear: { overflow in
            wouldOverflow = overflow
          }
        )
        
        if wouldOverflow {
          VStack(alignment: .leading) {
            HStack {
              LabelStrikeThroughView(
                text: oldIssue,
                textColor: Color.pink,
                color: .gray100
              )
              
              Circle()
                .fill(Color.gray100)
                .frame(width: 24, height: 24)
                .overlay {
                  Image("arrow-right", bundle: .module)
                    .resizable()
                    .frame(width: 20, height: 20)
                }
            }
            
            LabelView(
              title: issue,
              textColor: Color.primary700,
              radius: 12
            )
          }
          .padding(.bottom, 8)
          
        } else {
          HStack {
            LabelStrikeThroughView(
              text: oldIssue,
              textColor: Color.pink,
              color: .gray050
            )
            
            Circle()
              .fill(Color.gray100)
              .frame(width: 24, height: 24)
              .overlay {
                Image("arrow-right", bundle: .module)
                  .resizable()
                  .frame(width: 20, height: 20)
              }
            
            LabelView(
              title: issue,
              textColor: Color.primary700,
              radius: 12
            )
          }
          .padding(.bottom, 8)
        }
        
        LineShape()
          .stroke(Color.gray200, style: StrokeStyle(lineWidth: 1, lineJoin: .round, dash: [10, 5]))
          .frame(maxWidth: .infinity, maxHeight: 1)
        
        Text("Advokat telah mengubah kategori konsultasi")
          .captionLexend(size: 12)
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 8)
      .background(Color.white)
      .frame(maxWidth: .infinity, alignment: .leading)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8).stroke(Color.gray100, lineWidth: 1)
      }
      .padding(.horizontal, 16)
    }
  }
  
  @ViewBuilder
  func issueTagView() -> some View {
    TextOverflowDetector(
      text1: issue,
      text2: subIssue,
      fontSize: 10,
      fontWeight: .regular,
      onAppear: { overflow in
        wouldOverflow = overflow
      }
    )
    
    if wouldOverflow {
      VStack(alignment: .leading) {
        LabelView(
          title: issue,
          textColor: Color.primaryInfo600,
          radius: 12
        )
        
        LabelView(
          title: subIssue,
          textColor: Color.gray600,
          radius: 12
        )
      }
      .padding(.bottom, 8)
      
    } else {
      HStack {
        LabelView(
          title: issue,
          textColor: Color.primaryInfo600,
          radius: 20
        )
        
        LabelView(
          title: subIssue,
          textColor: Color.gray600,
          radius: 20
        )
      }
      .padding(.bottom, 8)
    }
  }
}

extension ConsultationSummaryView {
  
  public var expiredDays: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.locale = .init(identifier: "id")
    let dates = dateFormatter.date(from: userCases.stop_time ?? "")
    return "\(dates?.addingHour(by: 24)!.formatted(with: "dd MMMM") ?? "")"
  }
  
  public var expiredHoursStop: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.locale = .init(identifier: "id")
    let dates = dateFormatter.date(from: userCases.stop_time ?? "")
    return "\(dates?.addingHour(by: 24)!.formatted(with: "HH.mm") ?? "")"
  }
  
  public func getExpiredDaysHoursStop() -> String {
    return "Hingga \(expiredDays), pukul \(expiredHoursStop)"
  }
  
  public var didHaveSubIssue: Bool {
    return userCases.summary?.skill_type?.name != nil
  }
  
  public var subIssue: String {
    return "Jenis Kasus: \(userCases.summary?.skill_type?.name ?? "")"
  }
  
  public var issue: String {
    return userCases.summary?.skill?.name ?? ""
  }
  
  public var hasEdited: Bool {
    guard let editedAt = userCases.summary?.edited_at else { return false }
    return !editedAt.isEmpty
  }
  
  public var oldIssue: String {
    return userCases.skill?.name ?? ""
  }
  
  public var isSkillHasEdited: Bool {
    guard let oldSkill = userCases.skill?.id,
          let newSkill = userCases.summary?.skill?.id else {
      return false
    }
    
    return oldSkill != newSkill
  }
  
  public var editedDate: String {
    if let editedAt = userCases.summary?.edited_at,
       let dateString = editedAt.toDateNew()?.stringFormatSummary(){
      return dateString
    }
    
    return ""
  }
  
  public var isSummaryHasBeenSent: Bool {
    return userCases.summary?.matter != nil
  }
  
  public func showHistoryChat() -> Bool {
    var result = false
    if let stopTime = userCases.stop_time,
       let date = stopTime.toDate(),
       let expiredChatDay = date.addingHour(by: 24) {
      
      let comparison = expiredChatDay.compare(Date())
      result = comparison.rawValue != -1
      
    }
    
    return result
  }
  
  public func isRatingEmpty() -> Bool {
    return userCases.lawyer_rating?.value == nil
  }
  
  public func getRecommendations() -> [String] {
    return userCases
      .summary?
      .recommendations?
      .map { $0.description ?? "" } ?? []
  }
  
  public func navigateToChat(
    _ userCases: UserCases,
    clientID: Int,
    clientName: String
  ) {
    onTapShowChat?(userCases, clientID, clientName)
  }
  
}
