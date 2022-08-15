//
//  CastCollectionViewCell.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 14.08.2022.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CastCollectionViewCellIdentifier"
    static let nibName: String = "CastCollectionViewCell"

    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        actorImageView.layer.cornerRadius = 10
    }
    
    func setCell(image: URL?,
                 name: String) {
        if image != URL(string: "https://image.tmdb.org/t/p/w500") {
            actorImageView.kf.setImage(with: image)
        } else {
            actorImageView.image = UIImage(named: "placeholderImage")
        }
        nameLabel.text = name
    }
    
    override func prepareForReuse() {
        actorImageView.image = nil
        nameLabel.text = nil
    }
}
