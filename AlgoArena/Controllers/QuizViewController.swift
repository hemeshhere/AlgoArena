//
//  QuizViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class QuizViewController: UIViewController {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var quizProgressView: UIProgressView?
    @IBOutlet weak var progressLabel: UILabel?
    @IBOutlet weak var topicBadgeLabel: UILabel?

    // MARK: - Quiz State
    var questions: [Question] = []
    var topicTitle: String = "Arena Quiz"
    var currentQuestionIndex: Int = 0
    var score: Int = 0
    var onQuizCompleted: ((Bool) -> Void)?

    private var optionButtons: [UIButton] = []
    private var currentOptions: [String] = []
    private var isAnswerSubmitted: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = topicTitle
        optionButtons = [option1Button, option2Button, option3Button, option4Button]

        for (index, button) in optionButtons.enumerated() {
            button.tag = index
        }

        topicBadgeLabel?.text = topicTitle
        loadQuestion()
    }

    func loadQuestion() {
        guard currentQuestionIndex < questions.count else {
            finishQuiz()
            return
        }

        isAnswerSubmitted = false
        let current = questions[currentQuestionIndex]

        // Update progress indicators
        let progress = Float(currentQuestionIndex) / Float(max(1, questions.count))
        quizProgressView?.setProgress(progress, animated: true)
        progressLabel?.text = "Question \(currentQuestionIndex + 1) of \(questions.count)"

        // Update Question text
        questionLabel.text = decodeHTMLEntities(current.question)

        // Populate options
        currentOptions = current.shuffledAnswers
        let optionLetters = ["A", "B", "C", "D"]

        for (index, button) in optionButtons.enumerated() {
            button.isEnabled = true
            button.layer.borderWidth = 0
            button.configuration?.baseBackgroundColor = .secondarySystemFill
            button.configuration?.baseForegroundColor = .label

            if index < currentOptions.count {
                let text = decodeHTMLEntities(currentOptions[index])
                let letter = optionLetters[index]
                button.setTitle("\(letter).  \(text)", for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }

    // MARK: - Storyboard Action
    @IBAction func optionTapped(_ sender: UIButton) {
        guard !isAnswerSubmitted else { return }
        isAnswerSubmitted = true

        optionButtons.forEach { $0.isEnabled = false }

        let selectedIndex = sender.tag
        guard selectedIndex < currentOptions.count else { return }

        let selectedAnswer = currentOptions[selectedIndex]
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = (selectedAnswer == currentQuestion.correct_answer)

        if isCorrect {
            score += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            highlightButton(sender, isCorrect: true)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            highlightButton(sender, isCorrect: false)

            if let correctIndex = currentOptions.firstIndex(of: currentQuestion.correct_answer),
               correctIndex < optionButtons.count {
                highlightButton(optionButtons[correctIndex], isCorrect: true)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex += 1
            self.loadQuestion()
        }
    }

    private func highlightButton(_ button: UIButton, isCorrect: Bool) {
        button.configuration?.baseBackgroundColor = isCorrect ? .systemGreen : .systemRed
        button.configuration?.baseForegroundColor = .white
    }

    private func finishQuiz() {
        quizProgressView?.setProgress(1.0, animated: true)
        let total = questions.count
        let passed = score >= Int(ceil(Double(total) * 0.6))

        let result = GameEngine.shared.recordQuizResult(score: score, total: total, topicTitle: topicTitle)
        onQuizCompleted?(passed)

        let title = passed ? "Round Complete! 🎉" : "Round Finished"
        let eloString = result.eloChange >= 0 ? "+\(result.eloChange)" : "\(result.eloChange)"
        var message = "You scored \(score)/\(total).\nRating: \(GameEngine.shared.eloRating) (\(eloString))"

        if !result.newBadges.isEmpty {
            message += "\n🏆 Unlocked \(result.newBadges.count) new achievement!"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Return to Arena", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))

        present(alert, animated: true)
    }

    private func decodeHTMLEntities(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return string
    }
}
