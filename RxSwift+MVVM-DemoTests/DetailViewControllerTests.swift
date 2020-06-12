//
//  DetailViewControllerTests.swift
//  DetailViewControllerTests
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
import Moya

@testable import RxSwift_MVVM_Demo

class DetailViewControllerTests: XCTestCase {

  var viewModel: DetailViewModel!
  var disposeBag: DisposeBag!
  var scheduler: TestScheduler!
  var output: DetailViewModel.Output!

  override func setUpWithError() throws {
    viewModel = DetailViewModel()
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0, resolution: 0.01)

    let loadTrigger = scheduler.createHotObservable([.next(100, ())])
      .asDriver(onErrorJustReturn: ())

    let input = DetailViewModel.Input(loadTrigger: loadTrigger,
                                      provider: MoyaProvider<GitHub>(stubClosure: { _ in .immediate }),
                                      login: "")
    output = viewModel.transform(input: input)
  }

  // MARK: - RxTest

  func testIndicator() throws {
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

  func testUserDetailNameText() throws {
    let nameObserver = scheduler.createObserver(String?.self)

    output.nameText
      .bind(to: nameObserver)
      .disposed(by: disposeBag)

    scheduler.start()

    let nameExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, "Tom Preston-Werner"),
    ]

    XCTAssertEqual(nameObserver.events, nameExceptEvents)
  }

  func testUserDetailBioText() throws {
    let bioObserver = scheduler.createObserver(String?.self)

    output.bioText
      .bind(to: bioObserver)
      .disposed(by: disposeBag)

    scheduler.start()

    let bioExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, nil),
    ]

    XCTAssertEqual(bioObserver.events, bioExceptEvents)
  }

  func testUserDetailLocationText() throws {
    let locationObserver = scheduler.createObserver(String?.self)

    output.locationText
      .bind(to: locationObserver)
      .disposed(by: disposeBag)

    scheduler.start()

    let locationExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, "San Francisco"),
    ]

    XCTAssertEqual(locationObserver.events, locationExceptEvents)
  }

  func testUserDetailBlogText() throws {
    let blogObserver = scheduler.createObserver(String?.self)

    output.blogText
      .bind(to: blogObserver)
      .disposed(by: disposeBag)

    scheduler.start()

    let blogExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, ""),
      .next(100, "http://tom.preston-werner.com"),
    ]

    XCTAssertEqual(blogObserver.events, blogExceptEvents)
  }
}
