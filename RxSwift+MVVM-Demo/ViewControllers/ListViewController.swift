//
//  ListViewController.swift
//  RxSwift+MVVM-Demo
//
//  Created by SUNG HAO LIN on 2020/6/11.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class ListViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private var viewModel: ListViewModel?

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()

  private let dataSource = RxTableViewSectionedReloadDataSource<ListSection>(configureCell: {  (dataSource, tableView, indexPath, user) -> UITableViewCell in
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserTableViewCell ?? UserTableViewCell(style: .default, reuseIdentifier: "UserCell")
    cell.configure(with: user)
    return cell
  })

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "GitHub Users List"
    setupSubview()
    bindViewModel()
  }

  // MARK: - Private Methods

  private func setupSubview() {
    view.addSubview(tableView)
    tableView.addSubview(refreshControl)

    tableView.snp.makeConstraints {
      $0.size.equalToSuperview()
    }
  }

  private func bindViewModel() {
    viewModel = ListViewModel()

    let nextPageSignal = tableView.rx.reachedBottom(offset: 120.0).asSignal()
    let refreshTrigger = Driver<Void>.merge(.of(()), refreshControl.rx.controlEvent(.valueChanged).asDriver())

    let input = ListViewModel.Input(provider: MoyaProvider<GitHub>(),
                                    refreshTrigger: refreshTrigger,
                                    nextPageSignal: nextPageSignal)

    let output = viewModel?.transform(input: input)

    output?.list
      .map { [ListSection(header: "", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    output?.isLoading
      .filter { !$0 }
      .drive(refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)

    output?.errorRelay
      .subscribe(onNext: { [weak self] error in
        if let error = error as? MoyaError, let githubError = try? error.response?.map(GitHubError.self) {
          self?.showErrorAlert(with: githubError.message)
        } else {
          self?.showErrorAlert(with: error.localizedDescription)
        }
    }).disposed(by: disposeBag)

    tableView.rx.modelSelected(User.self)
      .subscribe(onNext: { [weak self] (user) in
        let controller = DetailViewController(user: user)
        self?.navigationController?.pushViewController(controller, animated: true)
    }).disposed(by: disposeBag)

    tableView.rx.itemSelected
      .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true)} )
      .disposed(by: disposeBag)
  }
}
