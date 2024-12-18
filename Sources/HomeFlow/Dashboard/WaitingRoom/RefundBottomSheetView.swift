//
//  CancelledConsultationRefundBottomSheet.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 08/12/24.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit

public class RefundBottomSheetView: BottomSheetContentView {
  
  let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Konsultasi Dibatalkan"
    lbl.font = .lexendFont(style: .title(size: 20))
    return lbl
  }()
  
  let subTitleLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Konsultasi ini dibatalkan, Perqara akan memulai prosedur Pengembalian Dana."
    lbl.font = .lexendFont(style: .body(size: 14))
    lbl.numberOfLines = 2
    return lbl
  }()
  
  let infoContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.gray050
    view.layer.borderColor = UIColor.gray200.cgColor
    view.layer.borderWidth = 1
    view.layer.cornerRadius = 12
    return view
  }()
  
  let amountContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.gray100
    view.layer.cornerRadius = 8
    return view
  }()
  
  let amountTitle: UILabel = {
    let lbl = UILabel()
    lbl.text = "Jumlah Pengembalian Dana"
    lbl.font = .lexendFont(style: .body(size: 14))
    return lbl
  }()
  
  let priceLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Rp 75.000"
    lbl.font = .lexendFont(style: .body(size: 14))
    lbl.textColor = UIColor.lightTextColor
    return lbl
  }()
  
  let reasonInfoLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Tujuan Pengembalian Dana"
    lbl.font = .lexendFont(style: .title(size: 20))
    return lbl
  }()
  
  let iconView: UIImageView = {
    let img = UIImageView(
      image: UIImage(
        named: "ic_checklist",
        in: .module,
        compatibleWith: .none
      )
    )
    return img
  }()
  
  let subReasonInfoLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Sistem akan secara otomatis memproses Pengembalian Dana dan mengembalikannya ke saldo E-Wallet Anda dalam waktu 3 x 24 jam (3 hari kerja)."
    lbl.font = .lexendFont(style: .body(size: 14))
    lbl.numberOfLines = 0
    return lbl
  }()
  
  let statusLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Status Pengembalian Dana bisa dilihat di riwayat konsultasi. "
    lbl.font = .lexendFont(style: .body(size: 14))
    lbl.textAlignment = .center
    lbl.numberOfLines = 2
    lbl.textColor = UIColor.lightTextColor
    return lbl
  }()
  
  let actionButton: UIButton = {
    let attributedString = NSAttributedString(
      string: "Isi form",
      attributes: [
        .font: UIFont.lexendFont(style: .title(size: 14)),
        .foregroundColor: UIColor.white
      ]
    )
    let btn = UIButton()
    btn.setAttributedTitle(attributedString, for: .normal)
    btn.backgroundColor = UIColor.buttonActiveColor
    btn.layer.cornerRadius = 8
    return btn
  }()
  
  let divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.gray100
    return view
  }()
  
  public override func setup() {
    super.setup()
    
    guard let store = store as? RefundPaymentSheetStore else { return }
    
    titleLabel.text = store.title
    subTitleLabel.text = store.getSubTitle()
    priceLabel.text = store.price
    subReasonInfoLabel.text = store.getDescriptions()
    actionButton.setAttributedTitle(store.buttonAttributedTitle(), for: .normal)
    
    actionButton.addTarget(
      self,
      action: #selector(didTapButton),
      for: .touchUpInside
    )
  }
  
  public override func setupView() {
    
    super.setupView()
    
    addSubview(titleLabel)
    addSubview(subTitleLabel)
    addSubview(infoContainerView)
    addSubview(statusLabel)
    addSubview(actionButton)
    infoContainerView.addSubview(amountContainerView)
    amountContainerView.addSubview(amountTitle)
    amountContainerView.addSubview(priceLabel)
    infoContainerView.addSubview(reasonInfoLabel)
    infoContainerView.addSubview(iconView)
    infoContainerView.addSubview(subReasonInfoLabel)
    infoContainerView.addSubview(divider)
    
    guard let store = store as? RefundPaymentSheetStore
    else { return }
    
    if store.paymentCategory == .EWALLET {
      setupForEWallet()
      return
    }
    
    setupForVA()
    
  }
  
  private func setupForVA() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).offset(36)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(16)
    }
    
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    
    infoContainerView.snp.makeConstraints { make in
      make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
      make.height.equalTo(190)
    }
    
    amountContainerView.snp.makeConstraints { make in
      make.top.equalTo(infoContainerView.snp.top).offset(24)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
      make.height.equalTo(42)
    }
    
    amountTitle.snp.makeConstraints { make in
      make.centerY.equalTo(amountContainerView.snp.centerY)
      make.leading.equalTo(amountContainerView.snp.leading).offset(12)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(amountContainerView.snp.centerY)
      make.trailing.equalTo(amountContainerView.snp.trailing).offset(-12)
    }
    
    divider.snp.makeConstraints { make in
      make.top.equalTo(amountContainerView.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
      make.height.equalTo(1)
    }
    
    reasonInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
    }
    
    iconView.snp.makeConstraints { make in
      make.top.equalTo(reasonInfoLabel.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
    }
    
    subReasonInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(reasonInfoLabel.snp.bottom).offset(12)
      make.leading.equalTo(iconView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
      make.bottom.equalTo(infoContainerView.snp.bottom).offset(-12)
    }
    
    statusLabel.snp.makeConstraints { make in
      make.top.equalTo(infoContainerView.snp.bottom).offset(24)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    
    actionButton.snp.makeConstraints { make in
      make.top.equalTo(statusLabel.snp.bottom).offset(8)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
      make.height.equalTo(40)
    }
  }
  
  private func setupForEWallet() {
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).offset(36)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(16)
    }
    
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    
    infoContainerView.snp.makeConstraints { make in
      make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
      make.height.equalTo(220)
    }
    
    amountContainerView.snp.makeConstraints { make in
      make.top.equalTo(infoContainerView.snp.top).offset(24)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
      make.height.equalTo(42)
    }
    
    amountTitle.snp.makeConstraints { make in
      make.centerY.equalTo(amountContainerView.snp.centerY)
      make.leading.equalTo(amountContainerView.snp.leading).offset(12)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(amountContainerView.snp.centerY)
      make.trailing.equalTo(amountContainerView.snp.trailing).offset(-12)
    }
    
    divider.snp.makeConstraints { make in
      make.top.equalTo(amountContainerView.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
      make.height.equalTo(1)
    }
    
    reasonInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
    }
    
    iconView.snp.makeConstraints { make in
      make.top.equalTo(reasonInfoLabel.snp.bottom).offset(12)
      make.leading.equalTo(infoContainerView.snp.leading).offset(12)
    }
    
    subReasonInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(reasonInfoLabel.snp.bottom).offset(12)
      make.leading.equalTo(iconView.snp.leading).offset(12)
      make.trailing.equalTo(infoContainerView.snp.trailing).offset(-12)
    }
    
    statusLabel.snp.makeConstraints { make in
      make.top.equalTo(infoContainerView.snp.bottom).offset(24)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    
    actionButton.snp.makeConstraints { make in
      make.top.equalTo(statusLabel.snp.bottom).offset(8)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
      make.height.equalTo(40)
    }
  }
  
  @objc
  private func didTapButton() {
    guard let store = store as? RefundPaymentSheetStore
    else { return }
    
    store.navigateTo()
  }
  
}
