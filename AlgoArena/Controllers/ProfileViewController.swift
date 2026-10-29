//
//  ProfileViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Profile Header Card
    private let headerCard = UIView()
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let rankBadgeView = UIView()
    private let rankBadgeLabel = UILabel()
    
    // Stats Row
    private let statsStackView = UIStackView()
    private let eloStatCard = UIView()
    private let eloStatValue = UILabel()
    private let streakStatCard = UIView()
    private let streakStatValue = UILabel()
    private let badgeStatCard = UIView()
    private let badgeStatValue = UILabel()
    
    // Achievements
    private let achievementsSectionLabel = UILabel()
    private let achievementsTableView = UITableView(frame: .zero, style: .plain)
    private var achievements: [Achievement] = []
    
    // Actions
    private let resetAccountButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        setupNavigation()
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func setupNavigation() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Header Card
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        headerCard.backgroundColor = .secondarySystemGroupedBackground
        headerCard.layer.cornerRadius = 20
        headerCard.layer.borderWidth = 1
        headerCard.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        headerCard.layer.shadowColor = UIColor.black.cgColor
        headerCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerCard.layer.shadowRadius = 8
        headerCard.layer.shadowOpacity = 0.05
        contentView.addSubview(headerCard)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarConfig = UIImage.SymbolConfiguration(pointSize: 52, weight: .regular)
        avatarImageView.image = UIImage(systemName: GameEngine.shared.avatarName, withConfiguration: avatarConfig)
        avatarImageView.tintColor = .systemIndigo
        avatarImageView.contentMode = .scaleAspectFit
        headerCard.addSubview(avatarImageView)

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        usernameLabel.textColor = .label
        usernameLabel.textAlignment = .center
        headerCard.addSubview(usernameLabel)

        rankBadgeView.translatesAutoresizingMaskIntoConstraints = false
        rankBadgeView.layer.cornerRadius = 10
        rankBadgeView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.15)
        headerCard.addSubview(rankBadgeView)

        rankBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        rankBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        rankBadgeLabel.textColor = .systemTeal
        rankBadgeLabel.textAlignment = .center
        rankBadgeView.addSubview(rankBadgeLabel)

        // Stats Row
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 10
        contentView.addSubview(statsStackView)

        let eloCard = createStatCard(title: "ELO RATING", valueLabel: eloStatValue, icon: "bolt.fill", color: .systemBlue)
        let streakCard = createStatCard(title: "STREAK", valueLabel: streakStatValue, icon: "flame.fill", color: .systemOrange)
        let badgesCard = createStatCard(title: "BADGES", valueLabel: badgeStatValue, icon: "trophy.fill", color: .systemYellow)

        statsStackView.addArrangedSubview(eloCard)
        statsStackView.addArrangedSubview(streakCard)
        statsStackView.addArrangedSubview(badgesCard)

        // Achievements Section
        achievementsSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementsSectionLabel.text = "ARENA ACHIEVEMENTS"
        achievementsSectionLabel.font = .systemFont(ofSize: 13, weight: .bold)
        achievementsSectionLabel.textColor = .secondaryLabel
        contentView.addSubview(achievementsSectionLabel)

        achievementsTableView.translatesAutoresizingMaskIntoConstraints = false
        achievementsTableView.backgroundColor = .clear
        achievementsTableView.isScrollEnabled = false
        achievementsTableView.separatorStyle = .none
        achievementsTableView.dataSource = self
        achievementsTableView.delegate = self
        achievementsTableView.register(AchievementCell.self, forCellReuseIdentifier: "AchievementCell")
        contentView.addSubview(achievementsTableView)

        // Reset Button
        resetAccountButton.translatesAutoresizingMaskIntoConstraints = false
        resetAccountButton.setTitle("Switch Handle / Reset", for: .normal)
        resetAccountButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        resetAccountButton.tintColor = .systemRed
        resetAccountButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        resetAccountButton.layer.cornerRadius = 14
        resetAccountButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        contentView.addSubview(resetAccountButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Header Card
            headerCard.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            avatarImageView.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerCard.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerCard.trailingAnchor, constant: -16),

            rankBadgeView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            rankBadgeView.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            rankBadgeView.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -18),
            rankBadgeView.heightAnchor.constraint(equalToConstant: 24),

            rankBadgeLabel.topAnchor.constraint(equalTo: rankBadgeView.topAnchor, constant: 4),
            rankBadgeLabel.bottomAnchor.constraint(equalTo: rankBadgeView.bottomAnchor, constant: -4),
            rankBadgeLabel.leadingAnchor.constraint(equalTo: rankBadgeView.leadingAnchor, constant: 12),
            rankBadgeLabel.trailingAnchor.constraint(equalTo: rankBadgeView.trailingAnchor, constant: -12),

            // Stats
            statsStackView.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStackView.heightAnchor.constraint(equalToConstant: 80),

            // Achievements label
            achievementsSectionLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 24),
            achievementsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            achievementsTableView.topAnchor.constraint(equalTo: achievementsSectionLabel.bottomAnchor, constant: 8),
            achievementsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            achievementsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            achievementsTableView.heightAnchor.constraint(equalToConstant: 450),

            // Reset button
            resetAccountButton.topAnchor.constraint(equalTo: achievementsTableView.bottomAnchor, constant: 12),
            resetAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetAccountButton.heightAnchor.constraint(equalToConstant: 48),
            resetAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28)
        ])
    }

    private func createStatCard(title: String, valueLabel: UILabel, icon: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor

        let iconIV = UIImageView(image: UIImage(systemName: icon))
        iconIV.translatesAutoresizingMaskIntoConstraints = false
        iconIV.tintColor = color
        iconIV.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
        titleLabel.textColor = .secondaryLabel

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 18, weight: .heavy)
        valueLabel.textColor = .label

        card.addSubview(iconIV)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            iconIV.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconIV.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            iconIV.widthAnchor.constraint(equalToConstant: 16),
            iconIV.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: iconIV.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconIV.trailingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -8),

            valueLabel.topAnchor.constraint(equalTo: iconIV.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -8)
        ])

        return card
    }

    private func loadData() {
        let engine = GameEngine.shared
        let name = engine.username.isEmpty ? "Coder" : engine.username
        usernameLabel.text = "@\(name)"

        let rank = engine.getRankTitle()
        rankBadgeLabel.text = rank.uppercased()

        let rankColor = engine.getRankColor()
        rankBadgeView.backgroundColor = rankColor.withAlphaComponent(0.15)
        rankBadgeLabel.textColor = rankColor

        eloStatValue.text = "\(engine.eloRating)"
        streakStatValue.text = "\(engine.currentStreak)d"
        
        achievements = Achievement.defaultAchievements(unlockedIds: engine.unlockedBadges)
        let unlockedCount = achievements.filter { $0.isUnlocked }.count
        badgeStatValue.text = "\(unlockedCount)/\(achievements.count)"

        achievementsTableView.reloadData()
    }

    // MARK: - UITableViewDataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as? AchievementCell else {
            return UITableViewCell()
        }
        cell.configure(with: achievements[indexPath.row])
        return cell
    }

    @objc private func resetTapped() {
        let alert = UIAlertController(
            title: "Reset Account",
            message: "Are you sure you want to reset your handle, Elo rating, and achievements? This action cannot be undone.",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Reset All Data", style: .destructive, handler: { _ in
            GameEngine.shared.resetProgress()
            
            // Return to onboarding
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let onboardingVC = storyboard.instantiateInitialViewController() {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = onboardingVC
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - AchievementCell

class AchievementCell: UITableViewCell {
    private let cardView = UIView()
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 14
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        contentView.addSubview(cardView)

        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.layer.cornerRadius = 10
        cardView.addSubview(iconContainer)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .label
        cardView.addSubview(titleLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        cardView.addSubview(descriptionLabel)

        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFit
        cardView.addSubview(statusImageView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 38),
            iconContainer.heightAnchor.constraint(equalToConstant: 38),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusImageView.leadingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusImageView.leadingAnchor, constant: -8),

            statusImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            statusImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 22),
            statusImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    func configure(with achievement: Achievement) {
        titleLabel.text = achievement.title
        descriptionLabel.text = achievement.description

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        iconImageView.image = UIImage(systemName: achievement.systemImageName, withConfiguration: iconConfig)

        if achievement.isUnlocked {
            iconContainer.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.15)
            iconImageView.tintColor = .systemYellow
            statusImageView.image = UIImage(systemName: "checkmark.seal.fill")
            statusImageView.tintColor = .systemGreen
            cardView.alpha = 1.0
        } else {
            iconContainer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.12)
            iconImageView.tintColor = .systemGray
            statusImageView.image = UIImage(systemName: "lock.fill")
            statusImageView.tintColor = .tertiaryLabel
            cardView.alpha = 0.65
        }
    }
}
