//
//  UserTableViewCell.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit
import SnapKit
import RxNuke
import Nuke
import RxSwift

class UserTableViewCell: UITableViewCell {

  private let stackSpacing: CGFloat = 10.0
  private let padding: CGFloat = 16.0
  private var disposeBag = DisposeBag()

  private lazy var avatarView: UIImageView = {
    let avatarView = UIImageView()
    avatarView.contentMode = .scaleAspectFit
    avatarView.snp.makeConstraints {
      $0.height.width.equalTo(50)
    }
    return avatarView
  }()

  private lazy var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.text = "User Name"
    return nameLabel
  }()

  private var staffBadge: StaffBadgeView = {
    let staffBadge = StaffBadgeView()
    staffBadge.isHidden = true
    return staffBadge
  }()

  private lazy var nameStackView: UIStackView = {
    let nameStackView = UIStackView(arrangedSubviews: [nameLabel, staffBadge])
    nameStackView.axis = .vertical
    nameStackView.distribution = .equalSpacing
    nameStackView.alignment = .leading
    return nameStackView
  }()

  private lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView(arrangedSubviews: [avatarView, nameStackView])
    mainStackView.axis = .horizontal
    mainStackView.distribution = .fill
    mainStackView.spacing = stackSpacing
    return mainStackView
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSubview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  // MARK: - Public Methods

  public func configure(with user: User) {
    Nuke.loadImage(with: ImageRequest(url: user.avatarURL,
                               processors: [ImageProcessors.Circle()]),
                                     into: avatarView)
    nameLabel.text = user.login
    staffBadge.isHidden = !user.isAdmin
  }

  // MARK: Private Methods

  private func setupSubview() {
    addSubview(mainStackView)
    mainStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(padding)
      $0.bottom.equalToSuperview().inset(padding).priority(.high)
    }
  }
}
