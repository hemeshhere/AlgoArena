//
//  ArenaViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class ArenaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Storyboard outlets maintained for compatibility
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!

    // Modern Header UI elements
    private let headerContainerView = UIView()
    private let playerCardView = UIView()
    private let avatarImageView = UIImageView()
    private let modernGreetingLabel = UILabel()
    private let subtitleGreetingLabel = UILabel()
    private let eloValueLabel = UILabel()
    private let rankBadgeView = UIView()
    private let rankBadgeLabel = UILabel()
    private let streakBadgeView = UIView()
    private let streakBadgeLabel = UILabel()
    private let modernProgressView = UIProgressView(progressViewStyle: .default)
    private let progressDescriptionLabel = UILabel()

    // Loading overlay
    private let loadingDimView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()

    var topics: [Topic] = [
        Topic(id: "1", title: "Arrays & Strings", subtitle: "Memory layouts & two-pointer drills", iconName: "square.grid.2x2", isCompleted: false),
        Topic(id: "2", title: "Hash Tables", subtitle: "O(1) lookups & collision resolution", iconName: "number.square", isCompleted: false),
        Topic(id: "3", title: "Trees & Graphs", subtitle: "DFS, BFS, and topological sorting", iconName: "network", isCompleted: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupHeaderCard()
        setupLoadingOverlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeaderUI()
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        title = "AlgoArena"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "TopicCell")
        
        // Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        updateHeaderUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func setupHeaderCard() {
        headerContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 216)
        headerContainerView.backgroundColor = .clear

        playerCardView.translatesAutoresizingMaskIntoConstraints = false
        playerCardView.backgroundColor = .secondarySystemGroupedBackground
        playerCardView.layer.cornerRadius = 20
        playerCardView.layer.borderWidth = 1
        playerCardView.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        playerCardView.layer.shadowColor = UIColor.black.cgColor
        playerCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        playerCardView.layer.shadowRadius = 8
        playerCardView.layer.shadowOpacity = 0.05

        // Avatar
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)
        avatarImageView.tintColor = .systemIndigo
        avatarImageView.contentMode = .scaleAspectFit

        // Greeting
        modernGreetingLabel.translatesAutoresizingMaskIntoConstraints = false
        modernGreetingLabel.font = .systemFont(ofSize: 18, weight: .bold)
        modernGreetingLabel.textColor = .label

        subtitleGreetingLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleGreetingLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleGreetingLabel.textColor = .secondaryLabel
        subtitleGreetingLabel.text = "Competitive Algorithm Arena"

        // Elo Number
        eloValueLabel.translatesAutoresizingMaskIntoConstraints = false
        eloValueLabel.font = .monospacedDigitSystemFont(ofSize: 22, weight: .heavy)
        eloValueLabel.textColor = .label

        // Rank Badge
        rankBadgeView.translatesAutoresizingMaskIntoConstraints = false
        rankBadgeView.layer.cornerRadius = 8
        rankBadgeView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.15)

        rankBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        rankBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        rankBadgeLabel.textColor = .systemTeal

        // Streak Badge
        streakBadgeView.translatesAutoresizingMaskIntoConstraints = false
        streakBadgeView.layer.cornerRadius = 8
        streakBadgeView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)

        streakBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        streakBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        streakBadgeLabel.textColor = .systemOrange

        // Progress bar
        modernProgressView.translatesAutoresizingMaskIntoConstraints = false
        modernProgressView.trackTintColor = .tertiarySystemGroupedBackground
        modernProgressView.progressTintColor = .systemIndigo
        modernProgressView.layer.cornerRadius = 4
        modernProgressView.clipsToBounds = true

        progressDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        progressDescriptionLabel.font = .systemFont(ofSize: 11, weight: .medium)
        progressDescriptionLabel.textColor = .secondaryLabel

        // Hierarchy
        headerContainerView.addSubview(playerCardView)
        playerCardView.addSubview(avatarImageView)
        playerCardView.addSubview(modernGreetingLabel)
        playerCardView.addSubview(subtitleGreetingLabel)
        playerCardView.addSubview(eloValueLabel)
        playerCardView.addSubview(rankBadgeView)
        rankBadgeView.addSubview(rankBadgeLabel)
        playerCardView.addSubview(streakBadgeView)
        streakBadgeView.addSubview(streakBadgeLabel)
        playerCardView.addSubview(modernProgressView)
        playerCardView.addSubview(progressDescriptionLabel)

        NSLayoutConstraint.activate([
            playerCardView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 10),
            playerCardView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            playerCardView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -16),
            playerCardView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -10),

            avatarImageView.topAnchor.constraint(equalTo: playerCardView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: playerCardView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            modernGreetingLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            modernGreetingLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            modernGreetingLabel.trailingAnchor.constraint(lessThanOrEqualTo: streakBadgeView.leadingAnchor, constant: -8),

            subtitleGreetingLabel.topAnchor.constraint(equalTo: modernGreetingLabel.bottomAnchor, constant: 2),
            subtitleGreetingLabel.leadingAnchor.constraint(equalTo: modernGreetingLabel.leadingAnchor),

            streakBadgeView.trailingAnchor.constraint(equalTo: playerCardView.trailingAnchor, constant: -16),
            streakBadgeView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            streakBadgeView.heightAnchor.constraint(equalToConstant: 26),

            streakBadgeLabel.topAnchor.constraint(equalTo: streakBadgeView.topAnchor, constant: 4),
            streakBadgeLabel.bottomAnchor.constraint(equalTo: streakBadgeView.bottomAnchor, constant: -4),
            streakBadgeLabel.leadingAnchor.constraint(equalTo: streakBadgeView.leadingAnchor, constant: 8),
            streakBadgeLabel.trailingAnchor.constraint(equalTo: streakBadgeView.trailingAnchor, constant: -8),

            // Elo row
            eloValueLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 18),
            eloValueLabel.leadingAnchor.constraint(equalTo: playerCardView.leadingAnchor, constant: 16),

            rankBadgeView.centerYAnchor.constraint(equalTo: eloValueLabel.centerYAnchor),
            rankBadgeView.leadingAnchor.constraint(equalTo: eloValueLabel.trailingAnchor, constant: 10),
            rankBadgeView.heightAnchor.constraint(equalToConstant: 24),

            rankBadgeLabel.topAnchor.constraint(equalTo: rankBadgeView.topAnchor, constant: 3),
            rankBadgeLabel.bottomAnchor.constraint(equalTo: rankBadgeView.bottomAnchor, constant: -3),
            rankBadgeLabel.leadingAnchor.constraint(equalTo: rankBadgeView.leadingAnchor, constant: 8),
            rankBadgeLabel.trailingAnchor.constraint(equalTo: rankBadgeView.trailingAnchor, constant: -8),

            // Progress bar
            modernProgressView.topAnchor.constraint(equalTo: eloValueLabel.bottomAnchor, constant: 14),
            modernProgressView.leadingAnchor.constraint(equalTo: playerCardView.leadingAnchor, constant: 16),
            modernProgressView.trailingAnchor.constraint(equalTo: playerCardView.trailingAnchor, constant: -16),
            modernProgressView.heightAnchor.constraint(equalToConstant: 8),

            progressDescriptionLabel.topAnchor.constraint(equalTo: modernProgressView.bottomAnchor, constant: 6),
            progressDescriptionLabel.leadingAnchor.constraint(equalTo: modernProgressView.leadingAnchor),
            progressDescriptionLabel.trailingAnchor.constraint(equalTo: modernProgressView.trailingAnchor)
        ])

        tableView.tableHeaderView = headerContainerView
    }

    private func setupLoadingOverlay() {
        loadingDimView.translatesAutoresizingMaskIntoConstraints = false
        loadingDimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        loadingDimView.layer.cornerRadius = 16
        loadingDimView.alpha = 0
        loadingDimView.isHidden = true

        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .systemIndigo

        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Loading Arena Questions..."
        loadingLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        loadingLabel.textColor = .label

        view.addSubview(loadingDimView)
        loadingDimView.addSubview(blurView)
        blurView.contentView.addSubview(loadingIndicator)
        blurView.contentView.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            loadingDimView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingDimView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingDimView.widthAnchor.constraint(equalToConstant: 220),
            loadingDimView.heightAnchor.constraint(equalToConstant: 90),

            blurView.topAnchor.constraint(equalTo: loadingDimView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: loadingDimView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: loadingDimView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: loadingDimView.trailingAnchor),

            loadingIndicator.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor, constant: -12),
            loadingIndicator.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),

            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor)
        ])
    }

    private func showLoading(_ show: Bool) {
        view.isUserInteractionEnabled = !show
        if show {
            loadingDimView.isHidden = false
            loadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.2) {
                self.loadingDimView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingDimView.alpha = 0
            }, completion: { _ in
                self.loadingDimView.isHidden = true
                self.loadingIndicator.stopAnimating()
            })
        }
    }

    func updateHeaderUI() {
        let name = GameEngine.shared.username.isEmpty ? "Coder" : GameEngine.shared.username
        let elo = GameEngine.shared.eloRating
        let rank = GameEngine.shared.getRankTitle()
        let streak = GameEngine.shared.currentStreak

        // Update storyboard labels if wired
        greetingLabel?.text = "Welcome, \(name)!"
        rankLabel?.text = "Rating: \(elo) - \(rank)"

        // Update modern header
        modernGreetingLabel.text = "Welcome, @\(name)"
        eloValueLabel.text = "\(elo) Elo"
        rankBadgeLabel.text = rank.uppercased()
        streakBadgeLabel.text = "🔥 \(streak) Day\(streak == 1 ? "" : "s")"

        let rankColor = GameEngine.shared.getRankColor()
        rankBadgeView.backgroundColor = rankColor.withAlphaComponent(0.15)
        rankBadgeLabel.textColor = rankColor

        let tierProgress = Float(elo % 200) / 200.0
        rankProgressView?.setProgress(tierProgress, animated: true)
        modernProgressView.setProgress(tierProgress, animated: true)

        let pointsToNext = 200 - (elo % 200)
        progressDescriptionLabel.text = "\(pointsToNext) Elo to next milestone • \(Int(tierProgress * 100))% completed"
    }

    // MARK: - UITableViewDataSource & Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "PRACTICE ARENAS"
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .secondaryLabel

        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as? TopicTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
            let topic = topics[indexPath.row]
            var content = cell.defaultContentConfiguration()
            content.text = topic.title
            content.secondaryText = topic.subtitle
            content.image = UIImage(systemName: topic.iconName)
            cell.contentConfiguration = content
            return cell
        }

        let topic = topics[indexPath.row]
        cell.configure(with: topic)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        let selectedTopic = topics[indexPath.row]
        showLoading(true)

        NetworkManager.shared.fetchQuestions { [weak self] result in
            guard let self = self else { return }
            self.showLoading(false)

            switch result {
            case .success(let questions):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let quizVC = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
                    quizVC.questions = questions
                    quizVC.topicTitle = selectedTopic.title
                    
                    quizVC.onQuizCompleted = { [weak self] didPass in
                        guard let self = self else { return }
                        if didPass {
                            self.topics[indexPath.row].isCompleted = true
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                    
                    self.navigationController?.pushViewController(quizVC, animated: true)
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Network Error",
                    message: "Unable to load questions: \(error.localizedDescription)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
