//
//  BaseViewController.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import UIKit

class BaseViewController<ViewModel>: UIViewController where ViewModel: BaseViewModel {
    lazy var viewModel: ViewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showLoading() {
        LoadingView.shared.startLoadingView()
    }

    func removeLoading() {
        LoadingView.shared.stopLoadingView()
    }

    func showAlert(_ errorType: customErrors) {
        let controller = UIAlertController(title: "Error", message: errorType.description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        controller.addAction(okAction)
        self.present(controller, animated: true)
    }
}
