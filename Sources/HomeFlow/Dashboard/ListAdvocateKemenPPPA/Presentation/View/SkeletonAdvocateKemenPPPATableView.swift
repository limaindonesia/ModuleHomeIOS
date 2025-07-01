//
//  Untitled.swift
//  HomeFlow
//
//  Created by muhammad yusuf on 29/06/25.
//

import Foundation
import UIKit
import SkeletonView

public class SkeletonAdvocateKemenPPPATableView: UIView,
                                        UITableViewDataSource,
                                        UITableViewDelegate,
                                        SkeletonTableViewDataSource {

  lazy var skeletonTableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.backgroundColor = .white
    tv.delegate = self
    tv.dataSource = self
    tv.isSkeletonable = true
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.separatorStyle = .none
    return tv
  }()

  public init() {
    super.init(frame: .zero)

    setupView()

    addSubview(skeletonTableView)
    NSLayoutConstraint.activate([
      skeletonTableView.topAnchor.constraint(equalTo: topAnchor),
      skeletonTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      skeletonTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      skeletonTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    skeletonTableView.reloadData()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {

    skeletonTableView.register(
      SkeletonKemenPPPATableViewCell.self,
      forCellReuseIdentifier: SkeletonKemenPPPATableViewCell.identifier
    )

  }

  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {

    return 10
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: SkeletonKemenPPPATableViewCell.identifier,
      for: indexPath
    )

    return cell

  }

  public func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {

    return 200
  }

  public func numSections(in collectionSkeletonView: UITableView) -> Int {
    return 1
  }

  public func collectionSkeletonView(
    _ skeletonView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return 10
  }

  public func collectionSkeletonView(
    _ skeletonView: UITableView,
    cellIdentifierForRowAt indexPath: IndexPath
  ) -> ReusableCellIdentifier {

    return SkeletonKemenPPPATableViewCell.identifier
  }

}
