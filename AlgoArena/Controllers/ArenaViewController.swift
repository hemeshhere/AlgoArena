//
//  ArenaViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class ArenaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!

    // Loading overlay
    private let loadingDimView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    var topics: [Topic] = [
        Topic(id: "1", title: "Arrays & Strings", subtitle: "Memory layouts & two-pointer drills", iconName: "square.grid.2x2", isCompleted: false),
        Topic(id: "2", title: "Hash Tables", subtitle: "O(1) lookups & collision resolution", iconName: "number.square", isCompleted: false),
        Topic(id: "3", title: "Trees & Graphs", subtitle: "DFS, BFS, and topological sorting", iconName: "network", isCompleted: false)
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingOverlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeaderUI()
        tableView?.reloadData()
    }

    private func setupTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 88

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }

    private func setupLoadingOverlay() {
        loadingDimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingDimView.translatesAutoresizingMaskIntoConstraints = false
        loadingDimView.isHidden = true

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white

        loadingDimView.addSubview(loadingIndicator)
        view.addSubview(loadingDimView)

        NSLayoutConstraint.activate([
            loadingDimView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingDimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingDimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingDimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: loadingDimView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingDimView.centerYAnchor)
        ])
    }

    private func showLoading(_ show: Bool) {
        loadingDimView.isHidden = !show
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        updateHeaderUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.tableView?.reloadData()
            sender.endRefreshing()
        }
    }

    private func updateHeaderUI() {
        let username = GameEngine.shared.username
        greetingLabel?.text = username.isEmpty ? "Welcome, Coder!" : "Welcome back, \(username)!"

        let elo = GameEngine.shared.eloRating
        let rank = GameEngine.shared.getRankTitle()
        rankLabel?.text = "Rating: \(elo) • \(rank)"

        let progress = Float(elo % 200) / 200.0
        rankProgressView?.setProgress(progress, animated: true)
        rankProgressView?.progressTintColor = GameEngine.shared.getRankColor()
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as? TopicTableViewCell else {
            return UITableViewCell()
        }

        let topic = topics[indexPath.row]
        cell.configure(with: topic)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

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
                            self.tableView?.reloadRows(at: [indexPath], with: .automatic)
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
