//
//  CancelledConsultationUIView.swift
//  HomeFlow
//
//  Created by Muhammad Yusuf on 05/12/24.
//

import Foundation
import UIKit
import GnDKit
import AprodhitKit
import Kingfisher

public class RefundKemenPPPAView: FileOwnerNibView {
  
  //Dependency
  private let store: RefundKemenPPPAStore
  
  @IBOutlet weak var lawyerContainerView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var categoryLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var fillFormButton: UIButton!
  
  public init(store: RefundKemenPPPAStore) {
    self.store = store
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func setupBundle() {
    bundleOrNil = .module
  }
  
  public override func setupView() {
    super.setupView()
    
    lawyerContainerView.layer.borderColor = UIColor.gray100.cgColor
    lawyerContainerView.layer.borderWidth = 1
    lawyerContainerView.layer.cornerRadius = 8
    
    titleLabel.font = UIFont.lexendFont(style: .title(size: 24))
    categoryLabel.font = UIFont.lexendFont(style: .body(size: 10))
    nameLabel.font = UIFont.lexendFont(style: .title(size: 16))
    dateLabel.font = UIFont.lexendFont(style: .caption(size: 10))
    
    nameLabel.textColor = UIColor.gray900
    categoryLabel.clipsToBounds = true
    categoryLabel.layer.cornerRadius = 12
    categoryLabel.layer.borderColor = UIColor.clear.cgColor
    categoryLabel.layer.borderWidth = 1
    categoryLabel.backgroundColor = UIColor.primaryInfo100
    categoryLabel.textColor = UIColor.primaryInfo600
    
    dateLabel.textColor = UIColor.gray400
    
    fillFormButton.tintColor = .buttonActiveColor
    fillFormButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    
    setupData()
  }
  
  private func setupData() {
    avatarImageView.kf.setImage(
      with: store.userCase.lawyer?.getImageName(),
      placeholder: UIImage(
        named: "img_placeholder_lawyer",
        in: .module,
        compatibleWith: .none
      )
    )
    avatarImageView.roundCorners(value: 12)
    titleLabel.text = store.title
    nameLabel.text = store.userCase.lawyer?.getName()
    dateLabel.text = store.userCase.getDateStringKemenPPPAReject()
    categoryLabel.text = "   " + (store.userCase.skill?.name ?? "") + "   "
    fillFormButton.setAttributedTitle(store.buttonAttributedTitle(), for: .normal)
  }

  @objc
  func didTapButton() {
    store.navigateTo()
  }
  
}
