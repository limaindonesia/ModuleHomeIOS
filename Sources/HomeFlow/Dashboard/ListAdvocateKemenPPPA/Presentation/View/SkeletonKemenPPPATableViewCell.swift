//
//  Untitled 2.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//

import UIKit
import SkeletonView

class SkeletonKemenPPPATableViewCell: UITableViewCell {

  static let identifier = "SkeletonKemenPPPATableViewCell"

  let containerView: UIView = {
    let cv = UIView()
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.isSkeletonable = true
    cv.skeletonCornerRadius = 25
    cv.layer.borderWidth = 2
    cv.layer.borderColor = UIColor.gray100.cgColor
    cv.layer.cornerRadius = 16
    return cv
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "The skeletons have a default appearance. So, when you don't specify the color, gradient or multilines properties, SkeletonView uses the default values"
    label.isSkeletonable = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.skeletonTextNumberOfLines = 3
    label.numberOfLines = 3
    return label
  }()

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none
    contentView.isSkeletonable = true
    contentView.addSubview(containerView)
    containerView.addSubview(titleLabel)

    NSLayoutConstraint.activate(
      [
        containerView.topAnchor.constraint(
          equalTo: contentView.topAnchor,
          constant: 16
        ),
        containerView.leadingAnchor.constraint(
          equalTo: contentView.leadingAnchor,
          constant: 16
        ),
        containerView.trailingAnchor.constraint(
          equalTo: contentView.trailingAnchor,
          constant: -16
        ),
        containerView.bottomAnchor.constraint(
          equalTo: contentView.bottomAnchor,
          constant: -16
        ),
      ]
    )

    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(
          equalTo: containerView.topAnchor,
          constant: 16
        ),
        titleLabel.leadingAnchor.constraint(
          equalTo: containerView.leadingAnchor,
          constant: 16
        ),
        titleLabel.trailingAnchor.constraint(
          equalTo: containerView.trailingAnchor,
          constant: -16
        ),
        titleLabel.bottomAnchor.constraint(
          equalTo: containerView.bottomAnchor,
          constant: -16
        )
      ]
    )

    contentView.showAnimatedSkeleton()

    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
