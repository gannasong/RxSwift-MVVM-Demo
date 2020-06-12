//
//  RxSwift_MVVM_DemoTests.swift
//  RxSwift+MVVM-DemoTests
//
//  Created by SUNG HAO LIN on 2020/6/11.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
import Moya

@testable import RxSwift_MVVM_Demo

class RxSwift_MVVM_DemoTests: XCTestCase {

  var viewModel: ListViewModel!
  var disposeBag: DisposeBag!
  var scheduler: TestScheduler!
  var output: ListViewModel.Output!

  override func setUpWithError() throws {
    viewModel = ListViewModel()
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    let refreshTrigger = scheduler.createHotObservable([.next(100, ())])
      .asDriver(onErrorJustReturn: ())



    let input = ListViewModel.Input(provider: MoyaProvider<GitHub>(stubClosure: { _ in .immediate }),
                                    refreshTrigger: refreshTrigger,
                                    nextPageSignal: .empty())

    output = viewModel.transform(input: input)
  }

  // MARK: - RxTest

  func testIndicatorEvents() throws {
    let observer = scheduler.createObserver(Bool.self)

    output.isLoading
      .drive(observer)
      .disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Bool>>] = [
      .next(0, false),
      .next(100, true),
      .next(100, false)
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testListCount() throws {
    let observer = scheduler.createObserver(Int.self)

    output.list
      .map { $0.count }
      .bind(to: observer)
      .disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Int>>] = [
      .next(0, 0),
      .next(100, 10),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testUserData() throws {
    let observer = scheduler.createObserver(User?.self)

    output.list
      .map({ $0.last })
      .bind(to: observer)
      .disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<User?>>] = [
      .next(0, nil),
      .next(100, User(login: "brynary",
                         id: 19,
                  avatarURL: URL(string: "https://avatars0.githubusercontent.com/u/19?v=4")!,
                    isAdmin: false)),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }
}
