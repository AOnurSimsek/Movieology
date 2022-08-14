//
//  MainScreenTableViewCell.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    static let identifier: String = "MovieTableViewCellIdentifier"
    static let nibNabme: String = "MovieTableViewCell"
    static let cellHeight: CGFloat = 140

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
        if image != URL(string: "https://image.tmdb.org/t/p/w500") {
            movieImageView.kf.setImage(with: image)
        }
        movieDescriptionLabel.text = "\t" + description
        titleLabel.text = title
    }
    
}
