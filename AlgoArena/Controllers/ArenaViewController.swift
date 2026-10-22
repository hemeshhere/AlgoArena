//  ArenaViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class ArenaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let topics = [
        Topic(id: "1", title: "Arrays & Strings", subtitle: "Memory basics", iconName: "square.grid.2x2", isCompleted: false),
        Topic(id: "2", title: "Hash Tables", subtitle: "Fast lookups", iconName: "number.square", isCompleted: false),
        Topic(id: "3", title: "Trees & Graphs", subtitle: "Complex routing", iconName: "network", isCompleted: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let topic = topics[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = topic.title
        content.secondaryText = topic.subtitle
        content.image = UIImage(systemName: topic.iconName)
        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTopic = topics[indexPath.row]
        print("User tapped: \(selectedTopic.title). Fetching questions...")

        NetworkManager.shared.fetchQuestions { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    // 1. Locate the quiz screen using the Storyboard ID you set
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let quizVC = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
                        // 2. Pass the fetched API data directly to the variables on the new screen
                        quizVC.questions = questions
                        
                        // 3. Native iOS slide animation to the new screen
                        self.navigationController?.pushViewController(quizVC, animated: true)
                    }
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                    // Native iOS error alert
                    let alert = UIAlertController(
                        title: "Network Error",
                        message: "Failed to fetch questions. Please wait a few seconds and try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

