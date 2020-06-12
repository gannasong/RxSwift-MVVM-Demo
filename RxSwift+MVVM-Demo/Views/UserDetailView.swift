//
//  UserDetailView.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
  private let padding: CGFloat = 16.0
  private let iconSize: CGSize = CGSize(width: 45, height: 45)
  private let imageHeight: CGFloat = 200

  private(set) lazy var avatarImageView: UIImageView = {
    let avatarImageView = UIImageView()
    avatarImageView.contentMode = .scaleAspectFit
    avatarImageView.snp.makeConstraints {
      $0.height.equalTo(imageHeight)
    }
    return avatarImageView
  }()

  private(set) var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
    return nameLabel
  }()

  private(set) var bioLabel: UILabel = {
    let bioLabel = UILabel()
    bioLabel.textAlignment = .center
    bioLabel.numberOfLines = 0
    return bioLabel
  }()

  private lazy var middleBorderView: UIView = {
    let middleBorderView = UIView()
    middleBorderView.backgroundColor = .systemGray
    return middleBorderView
  }()

  private lazy var personaIconView: UIImageView = {
    let personaIconView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    personaIconView.contentMode = .scaleAspectFit
    personaIconView.snp.makeConstraints {
      $0.width.equalTo(iconSize.width)
      $0.height.equalTo(iconSize.height)
    }
    return personaIconView
  }()

  private(set) var loginLabel: UILabel = {
    let loginLabel = UILabel()
    return loginLabel
  }()

  private(set) var staffBadge: StaffBadgeView = {
    let staffBadge = StaffBadgeView()
    staffBadge.isHidden = true
    return staffBadge
  }()

  private lazy var locationIconView: UIImageView = {
    let locationIconView = UIImageView(image: UIImage(systemName: "location.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    locationIconView.contentMode = .scaleAspectFit
    locationIconView.snp.makeConstraints {
      $0.width.equalTo(iconSize.width)
      $0.height.equalTo(iconSize.height)
    }
    return locationIconView
  }()

  private(set) var locationLabel: UILabel = {
    let locationLabel = UILabel()
    return locationLabel
  }()

  private lazy var blogIconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "link")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.width.equalTo(iconSize.width)
      make.height.equalTo(iconSize.height)
    }
    return imageView
  }()

  private(set) var blogTextView: UITextView = {
    let blogTextView = UITextView()
    blogTextView.isEditable = false
    blogTextView.isScrollEnabled = false
    blogTextView.textContainer.lineFragmentPadding = 0
    blogTextView.font = UIFont.systemFont(ofSize: 15)
    blogTextView.dataDetectorTypes = .link
    return blogTextView
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupSubview() {
    let imageStackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, bioLabel])
    imageStackView.axis = .vertical
    imageStackView.spacing = padding
    imageStackView.distribution = .equalSpacing

    addSubview(imageStackView)
    addSubview(middleBorderView)

    imageStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(padding)
    }

    middleBorderView.snp.makeConstraints {
      $0.top.equalTo(imageStackView.snp.bottom).offset(padding)
      $0.leading.trailing.equalToSuperview().inset(padding)
      $0.height.equalTo(1)
    }

    let loginStackView = UIStackView(arrangedSubviews: [loginLabel, staffBadge])
    loginStackView.axis = .vertical
    loginStackView.distribution = .equalSpacing
    loginStackView.alignment = .leading

    let personaStackView = UIStackView(arrangedSubviews: [personaIconView, loginStackView])
    personaStackView.axis = .horizontal
    personaStackView.spacing = padding

    let locationStackView = UIStackView(arrangedSubviews: [locationIconView, locationLabel])
    locationStackView.axis = .horizontal
    locationStackView.spacing = padding

    let blogStackView = UIStackView(arrangedSubviews: [blogIconView, blogTextView])
    blogStackView.axis = .horizontal
    blogStackView.spacing = padding
    blogStackView.alignment = .center

    let detailStackView = UIStackView(arrangedSubviews: [personaStackView, locationStackView, blogStackView])
    detailStackView.axis = .vertical
    detailStackView.spacing = padding

    addSubview(detailStackView)
    detailStackView.snp.makeConstraints {
      $0.top.equalTo(middleBorderView.snp.bottom).offset(padding)
      $0.leading.trailing.equalToSuperview().inset(padding)
    }
  }
}
