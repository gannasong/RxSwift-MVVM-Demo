//
//  ViewModelType.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
