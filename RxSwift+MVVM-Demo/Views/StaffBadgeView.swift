//
//  StaffBadgeView.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class StaffBadgeView: UILabel {
  private let inset = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }

  override var intrinsicContentSize: CGSize {
    get {
      var contentSize = super.intrinsicContentSize
      contentSize.height += inset.top + inset.bottom
      contentSize.width += inset.left + inset.right
      return contentSize
    }
  }

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: inset))
  }

  // MARK: - Private MEthods

  private func setup() {
    text = "STAFF"
    font = UIFont.boldSystemFont(ofSize: 12)
    textColor = .white
    backgroundColor = .systemRed
    layer.masksToBounds = true
  }
}
