//
//  TopicTableViewCell.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    
    // Storyboard outlets kept for storyboard compatibility
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    // Modern UI Elements
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.04
        return view
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.12)
        return view
    }()
    
    private let customIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemIndigo
        return iv
    }()
    
    private let customTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let customSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .systemGreen
        label.text = "COMPLETED"
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .tertiaryLabel
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var hasSetupProgrammaticUI = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCardLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardLayout()
    }
    
    private func setupCardLayout() {
        guard !hasSetupProgrammaticUI else { return }
        hasSetupProgrammaticUI = true
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Remove existing subviews if any from prototype cell
        contentView.addSubview(cardView)
        cardView.addSubview(iconContainer)
        iconContainer.addSubview(customIconImageView)
        cardView.addSubview(customTitleLabel)
        cardView.addSubview(customSubtitleLabel)
        cardView.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        cardView.addSubview(chevronImageView)
        
        // Wire up outlets to custom views in case external code references them
        iconImageView = customIconImageView
        titleLabel = customTitleLabel
        subtitleLabel = customSubtitleLabel
        
        NSLayoutConstraint.activate([
            // Card constraints with margin
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Icon container
            iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 44),
            iconContainer.heightAnchor.constraint(equalToConstant: 44),
            
            // Icon
            customIconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            customIconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            customIconImageView.widthAnchor.constraint(equalToConstant: 24),
            customIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title
            customTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            customTitleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
            customTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeView.leadingAnchor, constant: -8),
            
            // Subtitle
            customSubtitleLabel.topAnchor.constraint(equalTo: customTitleLabel.bottomAnchor, constant: 4),
            customSubtitleLabel.leadingAnchor.constraint(equalTo: customTitleLabel.leadingAnchor),
            customSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),
            customSubtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -14),
            
            // Chevron
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),
            
            // Badge
            badgeView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            badgeView.centerYAnchor.constraint(equalTo: customTitleLabel.centerYAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: 20),
            
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 2),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -2),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 6),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -6)
        ])
    }
    
    func configure(with topic: Topic) {
        setupCardLayout()
        
        customTitleLabel.text = topic.title
        customSubtitleLabel.text = topic.subtitle
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        customIconImageView.image = UIImage(systemName: topic.iconName, withConfiguration: config)
        
        // Topic theme color variation based on ID
        switch topic.id {
        case "1":
            iconContainer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
            customIconImageView.tintColor = .systemBlue
        case "2":
            iconContainer.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.12)
            customIconImageView.tintColor = .systemPurple
        case "3":
            iconContainer.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.12)
            customIconImageView.tintColor = .systemIndigo
        default:
            iconContainer.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.12)
            customIconImageView.tintColor = .systemTeal
        }
        
        badgeView.isHidden = !topic.isCompleted
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.15) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.cardView.backgroundColor = highlighted ? .tertiarySystemGroupedBackground : .secondarySystemGroupedBackground
        }
    }
}
