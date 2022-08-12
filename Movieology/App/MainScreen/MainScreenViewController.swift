//
//  MainScreenViewController.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit
import SnapKit

enum MainScreenState {
    case popularMovies
    case nextPage
    case search
}

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {

    private lazy var searchTextField: UITextField = UITextField()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var emptyView: UIView = UIView()
    private lazy var tableView: UITableView = UITableView()

    private var screenState: Observable<MainScreenState> = Observable(.popularMovies)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTableView()
        bind()
    }

    private func bind() {
        screenState.bind { [weak self] stateValue in
            guard let self = self
            else { return }
            self.showLoading()
            switch stateValue {
            case .popularMovies:
                self.titleLabel.text = "Popular Movies"
                self.viewModel.getPopularMovies()
            case .nextPage:
                self.viewModel.getPopularMovies(isNextPage: true)
            case .search:
                self.titleLabel.text = "Search Results"
                self.viewModel.search(text: self.searchTextField.text ?? "")
            }
        }

        viewModel.popularMovies.bind { [weak self] _ in
            guard let self = self
            else { return }
            self.removeLoading()

            if self.viewModel.popularMovies.value.isEmpty {
                self.emptyView.isHidden = false
                self.tableView.isHidden = true
            } else {
                print("popular bind a girdim")
                self.emptyView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }

        }

        viewModel.error.bind { [weak self] _error in
            if let error = _error {
                self?.showAlert(error)
                self?.removeLoading()
            }
        }

        viewModel.searchResults.bind { [weak self] _ in
            self?.removeLoading()
            self?.tableView.reloadData()
        }

    }

}

extension MainScreenViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor(hexString: "071037")
        searchTextField.backgroundColor = UIColor(hexString: "2E3656")
        searchTextField.setSearchBar()
        searchTextField.delegate = self

        titleLabel.font = UIFont(name: "Roboto-Medium", size: 22)
        titleLabel.textColor = .white
    }

    private func setLayout() {
        self.view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }

        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(15)
            make.trailing.equalTo(self.view.snp.trailing).offset(15)
            make.height.equalTo(25)
        }

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
    }
}

//MARK: - TableView Properties
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 120
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(UINib(nibName: MovieTableViewCell.nibNabme, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.register(UINib(nibName: ActorTableViewCell.nibNabme, bundle: nil),
                           forCellReuseIdentifier: ActorTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount(screenState: screenState.value, section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount(screenState: screenState.value)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView: tableView, indexPath: indexPath, screenState: self.screenState.value)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if screenState.value == .search {
            return viewModel.getSectionHeader(section: section)
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if screenState.value == .search {
            return 50
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (screenState.value == .nextPage || screenState.value == .popularMovies) && indexPath.row == viewModel.popularMovies.value.count-1 {
            screenState.value = .nextPage
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch screenState.value {
        case .popularMovies:
            return MovieTableViewCell.cellHeight
        case .nextPage:
            return MovieTableViewCell.cellHeight
        case .search:
            return UITableView.automaticDimension
        }
    }

}

//MARK: - TextFieldDelegates
extension MainScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 1 {
            screenState.value = .search
        } else {
            screenState.value = .popularMovies
        }
    }
}
