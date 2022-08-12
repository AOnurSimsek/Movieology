//
//  MainScreenTableViewCell.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit
import Kingfisher

class MainScreenTableViewCell: UITableViewCell {

    static let identifier: String = "MainScreenTableViewCellIdentifier"
    static let nibNabme: String = "MainScreenTableViewCell"
    static let cellHeight: Int = 140

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setUI() {
        movieImageView.addWhiteShadow()
    }

    func setCell(image: URL?,
                 title: String,
                 description: String) {
        movieImageView.kf.setImage(with: image)
        movieDescriptionLabel.text = "\t" + description
        titleLabel.text = title
    }
    
}
