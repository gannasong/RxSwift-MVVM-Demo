//
//  ListViewModel.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya

class ListViewModel: ViewModelType {

  private let pageSize: Int = 20
  private var disposeBag = DisposeBag()

  // MARK: - ViewModelType

  struct Input {
    let provider: MoyaProvider<GitHub>
    let refreshTrigger: Driver<Void>
    let nextPageSignal: Signal<Void>
  }

  struct Output {
    let list: BehaviorRelay<[User]>
    let isLoading: Driver<Bool>
    let errorRelay: PublishRelay<Error>
  }

  func transform(input: Input) -> Output {
    let pageSize = self.pageSize
    let since = BehaviorRelay<Int>(value: 0)
    let activityIndicator = ActivityIndicator()
    let list = BehaviorRelay<[User]>(value: [])
    let errorRelay = PublishRelay<Error>()

    input
      .refreshTrigger
      .drive(onNext: { since.accept(0) })
      .disposed(by: disposeBag)

    input.refreshTrigger
      .asObservable()
      .flatMapLatest {
        input.provider.rx.request(.getUserList(since: since.value, pageSize: pageSize))
          .filterSuccessfulStatusCodes()
          .map([User].self)
          .trackActivity(activityIndicator)
          .do(onError: { errorRelay.accept($0) })
          .catchErrorJustReturn([])
      }
      .bind(to: list)
      .disposed(by: disposeBag)

    input.nextPageSignal
      .asObservable()
      .flatMapLatest {
        input.provider.rx.request(.getUserList(since: since.value, pageSize: pageSize))
          .filterSuccessfulStatusCodes()
          .map([User].self)
          .trackActivity(activityIndicator)
          .do(onError: { errorRelay.accept($0) })
          .catchErrorJustReturn([])
    }
    .map { list.value + $0 }
    .bind(to: list)
    .disposed(by: disposeBag)

    list
      .map { $0.last?.id }
      .unwrap()
      .bind(to: since)
      .disposed(by: disposeBag)

    return Output(list: list, isLoading: activityIndicator.asDriver(), errorRelay: errorRelay)
  }
}
