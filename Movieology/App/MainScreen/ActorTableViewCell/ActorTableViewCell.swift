//
//  ActorTableViewCell.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit

class ActorTableViewCell: UITableViewCell {

    static let identifier: String = "ActorTableViewCellIdentifier"
    static let nibNabme: String = "ActorTableViewCell"

    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setUI() {
        actorImageView.addWhiteShadow()
    }

    func setCell(image: URL?,
                 fullName: String) {
        if image != URL(string: "https://image.tmdb.org/t/p/w500") {
            actorImageView.kf.setImage(with: image)
        } else {
            actorImageView.image = UIImage(named: "placeholderImage")
        }
        actorNameLabel.text = fullName
    }
    
    func createEmptyCell() {
        actorImageView.image = UIImage(named: "emptyIcon")
        actorNameLabel.text = "We couldn't find a movie fan with the name you searched for"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actorImageView.image = nil
        actorNameLabel.text = nil
    }

}
