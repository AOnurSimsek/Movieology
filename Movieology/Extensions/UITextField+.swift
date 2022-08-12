//
//  UITextField+.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit

extension UITextField {

    func setSearchBar() {
        self.borderStyle = .none
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 20

        self.attributedPlaceholder = NSAttributedString( string: "Search Movie, Person etc.",
                                                         attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                            NSAttributedString.Key.font: UIFont(name: "Roboto-Light", size: 14)!])
        setLeftView()
        setRightView()
    }

   private func setLeftView() {

        let searchView: UIView = {
            let tempView = UIView()
            let tempImageView = UIImageView(image: UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate))
            tempImageView.tintColor = .lightGray
            tempImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
            tempView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            tempView.addSubview(tempImageView)
            return tempView
        }()
        self.leftView = searchView
        self.leftViewMode = .always
    }

    private func setRightView() {
        self.clearButtonMode = .whileEditing
    }
}
