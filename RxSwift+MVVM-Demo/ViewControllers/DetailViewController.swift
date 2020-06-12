//
//  DetailViewController.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/12.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Nuke

class DetailViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private var viewModel: DetailViewModel?
  private let user: User

  private lazy var userDetailView: UserDetailView = {
    let userDetailView = UserDetailView()
    return userDetailView
  }()

  private lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    activityIndicatorView.startAnimating()
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }()

  // MARK: - Initialization

  init(user: User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubview()
    bindViewModel()
  }

  // MARK: - Private Methods

  private func setupSubview() {
    view.backgroundColor = .systemBackground
    view.addSubview(userDetailView)
    userDetailView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }

    view.addSubview(activityIndicatorView)
    activityIndicatorView.center = view.center
  }

  private func bindViewModel() {
    Nuke.loadImage(with: ImageRequest(url: user.avatarURL, processors: [ImageProcessors.Circle()]), into: userDetailView.avatarImageView)
    userDetailView.loginLabel.text = user.login
    userDetailView.staffBadge.isHidden = !user.isAdmin

    self.viewModel = DetailViewModel()
    let loadTrigger = Driver<Void>.of(())

    let input = DetailViewModel.Input(loadTrigger: loadTrigger,
                                      provider: MoyaProvider<GitHub>(),
                                      login: user.login)
    let output = viewModel?.transform(input: input)

    output?.nameText
      .bind(to: userDetailView.nameLabel.rx.text)
      .disposed(by: disposeBag)

    output?.bioText
      .bind(to: userDetailView.bioLabel.rx.text)
      .disposed(by: disposeBag)

    output?.locationText
      .bind(to: userDetailView.locationLabel.rx.text)
      .disposed(by: disposeBag)

    output?.blogText
      .bind(to: userDetailView.blogTextView.rx.text)
      .disposed(by: disposeBag)

    output?.isLoading
      .drive(activityIndicatorView.rx.isAnimating)
      .disposed(by: disposeBag)

    output?.errorRelay
      .subscribe(onNext: { [weak self] (error) in
        if let error = error as? MoyaError, let githubError = try? error.response?.map(GitHubError.self) {
          self?.showErrorAlert(with: githubError.message)
        } else {
          self?.showErrorAlert(with: error.localizedDescription)
        }
      }).disposed(by: disposeBag)
  }
}

