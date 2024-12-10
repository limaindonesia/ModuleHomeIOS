//
//  CancelledConsultationUIView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/12/24.
//

import Foundation
import UIKit
import GnDKit
import AprodhitKit

public class RefundPaymentView: FileOwnerNibView {
  
  //Dependency
  private let store: RefundPaymentStore
  
  @IBOutlet weak var lawyerContainerView: UIView!
  
  @IBOutlet weak var refundContainerView: UIView!
  
  @IBOutlet weak var amountContainerView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var categoryLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var refundInfoLabel: UILabel!
  
  @IBOutlet weak var refundTitleLabel: UILabel!
  
  @IBOutlet weak var amountTitleLabel: UILabel!
  
  @IBOutlet weak var amountValueLabel: UILabel!
  
  @IBOutlet weak var refundDescriptionTitleLabel: UILabel!
  
  @IBOutlet weak var iconView: UIImageView!
  
  @IBOutlet weak var refundDescriptionLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var fillFormButton: UIButton!
  
  public init(store: RefundPaymentStore) {
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
    
    refundContainerView.layer.borderColor = UIColor.gray100.cgColor
    refundContainerView.layer.borderWidth = 1
    refundContainerView.layer.cornerRadius = 8
    refundContainerView.backgroundColor = UIColor.gray050
    amountContainerView.layer.cornerRadius = 8
    amountContainerView.backgroundColor = UIColor.gray100
    
    titleLabel.font = UIFont.lexendFont(style: .title(size: 24))
    categoryLabel.font = UIFont.lexendFont(style: .body(size: 10))
    nameLabel.font = UIFont.lexendFont(style: .title(size: 14))
    dateLabel.font = UIFont.lexendFont(style: .caption(size: 10))
    
    refundInfoLabel.font = UIFont.lexendFont(style: .caption(size: 14))
    refundTitleLabel.font = UIFont.lexendFont(style: .title(size: 16))
    amountTitleLabel.font = UIFont.lexendFont(style: .title(size: 12))
    amountValueLabel.font = UIFont.lexendFont(style: .body(size: 14))
    
    amountValueLabel.textColor = UIColor.lightTextColor
    
    refundDescriptionTitleLabel.font = UIFont.lexendFont(style: .title(size: 16))
    refundDescriptionLabel.font = UIFont.lexendFont(style: .caption(size: 12))
    statusLabel.font = UIFont.lexendFont(style: .caption(size: 12))
    
    let attributedTitle = NSAttributedString(
      string: "Isi form",
      attributes: [
        .font: UIFont.lexendFont(style: .title(size: 14)),
        .foregroundColor: UIColor.white
      ]
    )
    fillFormButton.setAttributedTitle(attributedTitle, for: .normal)
    fillFormButton.tintColor = .buttonActiveColor
  }
  
}
