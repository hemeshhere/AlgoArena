//
//  ProfileViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var eloLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var achievementsTableView: UITableView!
    @IBOutlet weak var resetAccountButton: UIButton!

    private var achievements: [Achievement] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func setupUI() {
        achievementsTableView?.dataSource = self
        achievementsTableView?.delegate = self
        achievementsTableView?.separatorStyle = .none
        achievementsTableView?.backgroundColor = .clear

        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.height ?? 64) / 2
        avatarImageView?.clipsToBounds = true
    }

    private func loadData() {
        let engine = GameEngine.shared
        let username = engine.username.isEmpty ? "Coder" : engine.username
        usernameLabel?.text = username
        rankLabel?.text = "\(engine.getRankTitle()) Tier"
        rankLabel?.textColor = engine.getRankColor()
        eloLabel?.text = "\(engine.eloRating)"
        streakLabel?.text = "\(engine.currentStreak) Days"

        achievements = Achievement.defaultAchievements(unlockedIds: engine.unlockedBadges)
        achievementsTableView?.reloadData()
    }

    // MARK: - Actions
    @IBAction func resetProgressTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Reset Account Data?",
            message: "This will clear your username, rating, streaks, and unlocked badges. You will return to onboarding.",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Reset Everything", style: .destructive, handler: { _ in
            GameEngine.shared.resetProgress()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = onboardingVC
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }

        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as? AchievementTableViewCell else {
            return UITableViewCell()
        }

        let achievement = achievements[indexPath.row]
        cell.configure(with: achievement)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
