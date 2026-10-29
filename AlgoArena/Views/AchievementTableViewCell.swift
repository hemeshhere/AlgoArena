//
//  AchievementTableViewCell.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 29/10/26.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(with achievement: Achievement) {
        titleLabel.text = achievement.title
        descriptionLabel.text = achievement.description

        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        iconImageView.image = UIImage(systemName: achievement.systemImageName, withConfiguration: config)

        if achievement.isUnlocked {
            iconImageView.tintColor = .systemYellow
            statusImageView.image = UIImage(systemName: "checkmark.seal.fill")
            statusImageView.tintColor = .systemGreen
            titleLabel.textColor = .label
            contentView.alpha = 1.0
        } else {
            iconImageView.tintColor = .tertiaryLabel
            statusImageView.image = UIImage(systemName: "lock.fill")
            statusImageView.tintColor = .tertiaryLabel
            titleLabel.textColor = .secondaryLabel
            contentView.alpha = 0.55
        }
    }
}
