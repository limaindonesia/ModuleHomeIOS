//
//  CancelledConsultationUIView.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 05/12/24.
//

import Foundation
import UIKit

public class CancelledConsultationView: UIView {
  
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
 
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
  }
}
