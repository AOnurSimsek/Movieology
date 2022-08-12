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
        print(image)
        actorImageView.kf.setImage(with: image)
        actorNameLabel.text = fullName
    }

}
