//
//  GitHub.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Moya

enum GitHub {
  case getUserList(since: Int, pageSize: Int)
  case getUserDetail(login: String)
}

extension GitHub: TargetType {

  var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }

  var path: String {
    switch self {
      case .getUserList:
        return "/users"
      case let .getUserDetail(login):
        return "/users/\(login)"
    }
  }

  var method: Method {
    return .get
  }

  var task: Task {
    switch self {
      case let .getUserList(since, pageSize):
        return .requestParameters(parameters: [ "since": since, "per_page": pageSize ], encoding: URLEncoding.default)
      case .getUserDetail:
        return .requestPlain
    }
  }

  var sampleData: Data {
    switch self {
      case .getUserList:
        return stubbedResponse("List")
      case .getUserDetail:
        return stubbedResponse("UserDetail")
    }
  }

  var headers: [String : String]? {
    return nil
  }

  func stubbedResponse(_ filename: String) -> Data! {
    let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
    let bundle = Bundle(path: bundlePath!)
    let path = bundle?.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
  }
}
