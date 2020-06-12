//
//  UserDetail.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Foundation

import Foundation

struct UserDetail: Codable {
  let login: String
  let id: Int
  let avatarURL: URL
  let isAdmin: Bool
  let name: String?
  let bio: String?
  let location: String?
  let blog: String

  enum CodingKeys: String, CodingKey {
    case login
    case id
    case avatarURL = "avatar_url"
    case isAdmin = "site_admin"
    case name
    case bio
    case location
    case blog
  }
}
