//
//  DetailViewModel.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya


class DetailViewModel: ViewModelType {

  private let disposeBag = DisposeBag()

  // MARK: - ViewModelType

  struct Input {
    let loadTrigger: Driver<Void>
    let provider: MoyaProvider<GitHub>
    let login: String
  }

  struct Output {
    let nameText: BehaviorRelay<String?>
    let bioText: BehaviorRelay<String?>
    let locationText: BehaviorRelay<String?>
    let blogText: BehaviorRelay<String>
    let isLoading: Driver<Bool>
    let errorRelay: PublishRelay<Error>
  }

  func transform(input: Input) -> Output {
    let activityIndicator = ActivityIndicator()
    let nameText = BehaviorRelay<String?>(value: nil)
    let bioText = BehaviorRelay<String?>(value: nil)
    let locationText = BehaviorRelay<String?>(value: nil)
    let blogText = BehaviorRelay<String>(value: "")
    let errorRelay = PublishRelay<Error>()

    let userDetail = input.loadTrigger
      .flatMapFirst {
        input.provider.rx.request(.getUserDetail(login: input.login))
          .filterSuccessfulStatusCodes()
          .map(UserDetail.self)
          .trackActivity(activityIndicator)
          .asObservable()
          .do(onError: { errorRelay.accept($0) })
          .asDriver(onErrorRecover: { _ in .empty() })
      }

    userDetail.map { $0.name }
      .drive(nameText)
      .disposed(by: disposeBag)

    userDetail
      .map { $0.bio }
      .drive(bioText)
      .disposed(by: disposeBag)

    userDetail
      .map { $0.location }
      .drive(locationText)
      .disposed(by: disposeBag)

    userDetail
      .map { $0.blog }
      .drive(blogText)
      .disposed(by: disposeBag)
    
    return Output(nameText: nameText,
                  bioText: bioText,
                  locationText: locationText,
                  blogText: blogText,
                  isLoading: activityIndicator.asDriver(),
                  errorRelay: errorRelay)
  }
}
