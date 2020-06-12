//
//  UIViewController+Alert.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

extension UIViewController {
  internal func showErrorAlert(with message: String) {
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok",
                                  style: .default))
    present(alert, animated: true)
  }
}
