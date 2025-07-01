//
//  KemenPPPASnakeBarNotificationView.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 30/06/25.
//

import UIKit
import AprodhitKit
import GnDKit

final class KemenPPPASnackbarView: UIView {

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return iv
    }()

    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.lexendFont(style: .caption(size: 14))
        lbl.textColor = UIColor.success900
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    init(message: String, imageName: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.success050
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: imageName, in: Bundle.module, compatibleWith: nil)

        label.text = message

        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
          stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
          stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
          stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
          stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
