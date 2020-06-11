//
//  User.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
  let login: String
  let id: Int
  let avatarURL: URL
  let isAdmin: Bool

  enum CodingKeys: String, CodingKey {
    case login
    case id
    case avatarURL = "avatar_url"
    case isAdmin = "site_admin"
  }
}
