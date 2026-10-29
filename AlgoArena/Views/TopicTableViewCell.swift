//
//  TopicTableViewCell.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(with topic: Topic) {
        titleLabel?.text = topic.title
        subtitleLabel?.text = topic.subtitle

        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        iconImageView?.image = UIImage(systemName: topic.iconName, withConfiguration: config)

        switch topic.id {
        case "1":
            iconImageView?.tintColor = .systemBlue
        case "2":
            iconImageView?.tintColor = .systemPurple
        case "3":
            iconImageView?.tintColor = .systemIndigo
        default:
            iconImageView?.tintColor = .systemTeal
        }

        checkmarkImageView?.isHidden = !topic.isCompleted
    }
}
