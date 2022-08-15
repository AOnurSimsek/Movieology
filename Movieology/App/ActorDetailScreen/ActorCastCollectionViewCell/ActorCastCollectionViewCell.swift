//
//  ActorCastCollectionViewCell.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 15.08.2022.
//

import UIKit

class ActorCastCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "ActorCastCollectionViewCellIdentifier"
    static let nibName: String = "ActorCastCollectionViewCell"

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI() {
        movieImageView.layer.cornerRadius = 6
        movieImageView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        mainView.layer.cornerRadius = 6
        mainView.layer.masksToBounds = true
        mainView.layer.borderColor = UIColor.white.cgColor
        mainView.layer.borderWidth = 2
        mainView.addWhiteShadow()
    }
    
    func setCell(image: URL?,
                 movieName: String,
                 movieCharacter: String) {
        if image != URL(string: "https://image.tmdb.org/t/p/w500") {
            movieImageView.kf.setImage(with: image)
        } else {
            movieImageView.image = UIImage(named: "placeholderImage")
        }
        
        titleLabel.attributedText = movieName.getTitleAttributedString(text: "/ " + movieCharacter, hightlightedText: movieName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        titleLabel.attributedText = nil
    }

}
