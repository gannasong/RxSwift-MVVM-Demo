//
//  ListSection.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import RxDataSources

struct ListSection {
  let header: String
  var items: [User]
}

extension ListSection: SectionModelType {
  init(original: ListSection, items: [User]) {
    self = original
    self.items = items
  }
}
