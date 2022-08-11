//
//  MainScreenViewController.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {

    private lazy var searchTextField: UITextField = UITextField()
    private lazy var searchIcon: UIButton = UIButton()
    private lazy var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - TableView Properties
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

//MARK: - TextFieldDelegates
extension MainScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
