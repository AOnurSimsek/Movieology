//
//  TitleHeaderView.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 13.08.2022.
//

import UIKit
import SnapKit

class TitleHeaderView: UIView {

    private lazy var titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        setUI()
        setLayout()
        titleLabel.text = title
    }

    private func setUI() {
        self.backgroundColor = UIColor(hexString: "2E3656")
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
    }

    private func setLayout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(15)
            make.trailing.equalTo(self.snp.trailing).offset(-15)
        }
    }

}
