//
//  QuizViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import UIKit

class QuizViewController: UIViewController {
    
    // The data passed from the Arena screen
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var topicTitle: String = "Algorithm Arena"
    var onQuizCompleted: ((Bool) -> Void)?
    
    private var score = 0
    private var currentOptions: [String] = []
    private var isAnswerSubmitted = false
    
    // UI Connections from Storyboard
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    // Header & Meta Views
    private let topBarView = UIView()
    private let closeButton = UIButton(type: .system)
    private let topicBadgeLabel = UILabel()
    private let progressLabel = UILabel()
    private let quizProgressView = UIProgressView(progressViewStyle: .default)
    
    private let difficultyBadge = UIView()
    private let difficultyLabel = UILabel()
    
    // Card container for question
    private let questionCardView = UIView()
    
    // Array of buttons for convenience
    private var optionButtons: [UIButton] = []
    private let optionLetters = ["A", "B", "C", "D"]
    
    // Results View
    private let resultsOverlayView = UIView()
    private let resultsCardView = UIView()
    private let resultsTrophyImageView = UIImageView()
    private let resultsTitleLabel = UILabel()
    private let resultsScoreLabel = UILabel()
    private let resultsEloPill = UIView()
    private let resultsEloLabel = UILabel()
    private let resultsBadgesStack = UIStackView()
    private let finishButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        optionButtons = [option1Button, option2Button, option3Button, option4Button]
        
        setupModernUI()
        setupResultsView()
        loadQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupModernUI() {
        // Top Bar
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarView)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let closeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: closeConfig), for: .normal)
        closeButton.tintColor = .secondaryLabel
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        topBarView.addSubview(closeButton)
        
        topicBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        topicBadgeLabel.font = .systemFont(ofSize: 13, weight: .bold)
        topicBadgeLabel.textColor = .systemIndigo
        topicBadgeLabel.text = topicTitle.uppercased()
        topBarView.addSubview(topicBadgeLabel)
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
        progressLabel.textColor = .secondaryLabel
        topBarView.addSubview(progressLabel)
        
        quizProgressView.translatesAutoresizingMaskIntoConstraints = false
        quizProgressView.trackTintColor = .tertiarySystemGroupedBackground
        quizProgressView.progressTintColor = .systemIndigo
        quizProgressView.layer.cornerRadius = 3
        quizProgressView.clipsToBounds = true
        view.addSubview(quizProgressView)
        
        // Difficulty Badge
        difficultyBadge.translatesAutoresizingMaskIntoConstraints = false
        difficultyBadge.layer.cornerRadius = 6
        difficultyBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.font = .systemFont(ofSize: 11, weight: .bold)
        difficultyLabel.textColor = .systemOrange
        difficultyBadge.addSubview(difficultyLabel)
        view.addSubview(difficultyBadge)
        
        // Style Question Label
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        questionLabel.textColor = .label
        questionLabel.textAlignment = .left
        questionLabel.numberOfLines = 0
        
        // Option Buttons Styling
        for (index, button) in optionButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.layer.cornerRadius = 14
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
            button.backgroundColor = .secondarySystemGroupedBackground
            button.tintColor = .label
            button.contentHorizontalAlignment = .leading
            
            // Modern UIButton configuration
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
            config.titleLineBreakMode = .byWordWrapping
            button.configuration = config
            
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
        }
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topBarView.heightAnchor.constraint(equalToConstant: 44),
            
            closeButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            
            topicBadgeLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 12),
            topicBadgeLabel.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            
            progressLabel.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            
            quizProgressView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 6),
            quizProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quizProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quizProgressView.heightAnchor.constraint(equalToConstant: 6),
            
            difficultyBadge.topAnchor.constraint(equalTo: quizProgressView.bottomAnchor, constant: 16),
            difficultyBadge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            difficultyBadge.heightAnchor.constraint(equalToConstant: 22),
            
            difficultyLabel.topAnchor.constraint(equalTo: difficultyBadge.topAnchor, constant: 3),
            difficultyLabel.bottomAnchor.constraint(equalTo: difficultyBadge.bottomAnchor, constant: -3),
            difficultyLabel.leadingAnchor.constraint(equalTo: difficultyBadge.leadingAnchor, constant: 8),
            difficultyLabel.trailingAnchor.constraint(equalTo: difficultyBadge.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupResultsView() {
        resultsOverlayView.translatesAutoresizingMaskIntoConstraints = false
        resultsOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        resultsOverlayView.alpha = 0
        resultsOverlayView.isHidden = true
        view.addSubview(resultsOverlayView)
        
        resultsCardView.translatesAutoresizingMaskIntoConstraints = false
        resultsCardView.backgroundColor = .secondarySystemGroupedBackground
        resultsCardView.layer.cornerRadius = 24
        resultsCardView.layer.borderWidth = 1
        resultsCardView.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        resultsOverlayView.addSubview(resultsCardView)
        
        resultsTrophyImageView.translatesAutoresizingMaskIntoConstraints = false
        let trophyConfig = UIImage.SymbolConfiguration(pointSize: 52, weight: .bold)
        resultsTrophyImageView.image = UIImage(systemName: "trophy.fill", withConfiguration: trophyConfig)
        resultsTrophyImageView.tintColor = .systemYellow
        resultsTrophyImageView.contentMode = .scaleAspectFit
        resultsCardView.addSubview(resultsTrophyImageView)
        
        resultsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsTitleLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        resultsTitleLabel.textColor = .label
        resultsTitleLabel.textAlignment = .center
        resultsTitleLabel.text = "Blitz Completed!"
        resultsCardView.addSubview(resultsTitleLabel)
        
        resultsScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsScoreLabel.font = .systemFont(ofSize: 16, weight: .medium)
        resultsScoreLabel.textColor = .secondaryLabel
        resultsScoreLabel.textAlignment = .center
        resultsCardView.addSubview(resultsScoreLabel)
        
        resultsEloPill.translatesAutoresizingMaskIntoConstraints = false
        resultsEloPill.layer.cornerRadius = 14
        resultsEloPill.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        resultsCardView.addSubview(resultsEloPill)
        
        resultsEloLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsEloLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        resultsEloLabel.textColor = .systemGreen
        resultsEloLabel.textAlignment = .center
        resultsEloPill.addSubview(resultsEloLabel)
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.setTitle("Return to Arena", for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        finishButton.backgroundColor = .systemIndigo
        finishButton.tintColor = .white
        finishButton.layer.cornerRadius = 16
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        resultsCardView.addSubview(finishButton)
        
        NSLayoutConstraint.activate([
            resultsOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultsOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            resultsCardView.centerXAnchor.constraint(equalTo: resultsOverlayView.centerXAnchor),
            resultsCardView.centerYAnchor.constraint(equalTo: resultsOverlayView.centerYAnchor),
            resultsCardView.widthAnchor.constraint(equalTo: resultsOverlayView.widthAnchor, constant: -48),
            
            resultsTrophyImageView.topAnchor.constraint(equalTo: resultsCardView.topAnchor, constant: 28),
            resultsTrophyImageView.centerXAnchor.constraint(equalTo: resultsCardView.centerXAnchor),
            resultsTrophyImageView.widthAnchor.constraint(equalToConstant: 60),
            resultsTrophyImageView.heightAnchor.constraint(equalToConstant: 60),
            
            resultsTitleLabel.topAnchor.constraint(equalTo: resultsTrophyImageView.bottomAnchor, constant: 16),
            resultsTitleLabel.leadingAnchor.constraint(equalTo: resultsCardView.leadingAnchor, constant: 20),
            resultsTitleLabel.trailingAnchor.constraint(equalTo: resultsCardView.trailingAnchor, constant: -20),
            
            resultsScoreLabel.topAnchor.constraint(equalTo: resultsTitleLabel.bottomAnchor, constant: 8),
            resultsScoreLabel.leadingAnchor.constraint(equalTo: resultsCardView.leadingAnchor, constant: 20),
            resultsScoreLabel.trailingAnchor.constraint(equalTo: resultsCardView.trailingAnchor, constant: -20),
            
            resultsEloPill.topAnchor.constraint(equalTo: resultsScoreLabel.bottomAnchor, constant: 18),
            resultsEloPill.centerXAnchor.constraint(equalTo: resultsCardView.centerXAnchor),
            resultsEloPill.heightAnchor.constraint(equalToConstant: 36),
            
            resultsEloLabel.topAnchor.constraint(equalTo: resultsEloPill.topAnchor, constant: 8),
            resultsEloLabel.bottomAnchor.constraint(equalTo: resultsEloPill.bottomAnchor, constant: -8),
            resultsEloLabel.leadingAnchor.constraint(equalTo: resultsEloPill.leadingAnchor, constant: 16),
            resultsEloLabel.trailingAnchor.constraint(equalTo: resultsEloPill.trailingAnchor, constant: -16),
            
            finishButton.topAnchor.constraint(equalTo: resultsEloPill.bottomAnchor, constant: 24),
            finishButton.leadingAnchor.constraint(equalTo: resultsCardView.leadingAnchor, constant: 24),
            finishButton.trailingAnchor.constraint(equalTo: resultsCardView.trailingAnchor, constant: -24),
            finishButton.heightAnchor.constraint(equalToConstant: 52),
            finishButton.bottomAnchor.constraint(equalTo: resultsCardView.bottomAnchor, constant: -24)
        ])
    }
    
    func loadQuestion() {
        guard currentQuestionIndex < questions.count else {
            showQuizResults()
            return
        }
        
        isAnswerSubmitted = false
        let current = questions[currentQuestionIndex]
        
        // Progress & Count
        progressLabel.text = "\(currentQuestionIndex + 1) / \(questions.count)"
        let targetProgress = Float(currentQuestionIndex + 1) / Float(questions.count)
        quizProgressView.setProgress(targetProgress, animated: true)
        
        // Difficulty
        let diff = current.difficulty.uppercased()
        difficultyLabel.text = diff
        switch current.difficulty.lowercased() {
        case "easy":
            difficultyBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            difficultyLabel.textColor = .systemGreen
        case "hard":
            difficultyBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            difficultyLabel.textColor = .systemRed
        default:
            difficultyBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            difficultyLabel.textColor = .systemOrange
        }
        
        // Question Text (HTML decoded)
        let decodedQuestion = decodeHTMLEntities(current.question)
        questionLabel.text = decodedQuestion
        
        // Options setup
        currentOptions = current.shuffledAnswers
        for (index, button) in optionButtons.enumerated() {
            button.isEnabled = true
            button.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
            button.backgroundColor = .secondarySystemGroupedBackground
            
            if index < currentOptions.count {
                let answerText = decodeHTMLEntities(currentOptions[index])
                let letter = optionLetters[index]
                
                var container = AttributeContainer()
                container.font = .systemFont(ofSize: 16, weight: .semibold)
                container.foregroundColor = UIColor.label
                
                var letterContainer = AttributeContainer()
                letterContainer.font = .monospacedSystemFont(ofSize: 15, weight: .bold)
                letterContainer.foregroundColor = UIColor.systemIndigo
                
                let attributedTitle = AttributedString("\(letter)   \(answerText)", attributes: container)
                button.configuration?.attributedTitle = attributedTitle
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
    
    private func decodeHTMLEntities(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil).string) ?? string
    }
    
    // MARK: - Actions
    
    @IBAction func optionTapped(_ sender: UIButton) {
        guard !isAnswerSubmitted else { return }
        isAnswerSubmitted = true
        
        // Disable all buttons to prevent double-tap
        optionButtons.forEach { $0.isEnabled = false }
        
        let selectedIndex = sender.tag
        guard selectedIndex < currentOptions.count else { return }
        
        let selectedAnswer = currentOptions[selectedIndex]
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = (selectedAnswer == currentQuestion.correct_answer)
        
        if isCorrect {
            score += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            animateButton(sender, isCorrect: true)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            animateButton(sender, isCorrect: false)
            
            // Highlight the correct answer
            if let correctIndex = currentOptions.firstIndex(of: currentQuestion.correct_answer),
               correctIndex < optionButtons.count {
                let correctButton = optionButtons[correctIndex]
                animateButton(correctButton, isCorrect: true)
            }
        }
        
        // Advance to next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex += 1
            self.loadQuestion()
        }
    }
    
    private func animateButton(_ button: UIButton, isCorrect: Bool) {
        UIView.animate(withDuration: 0.25) {
            if isCorrect {
                button.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
                button.layer.borderColor = UIColor.systemGreen.cgColor
            } else {
                button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
                button.layer.borderColor = UIColor.systemRed.cgColor
            }
            button.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
    }
    
    private func showQuizResults() {
        let (eloDelta, _) = GameEngine.shared.recordQuizResult(
            score: score,
            total: questions.count,
            topicTitle: topicTitle
        )
        
        resultsScoreLabel.text = "You scored \(score) out of \(questions.count) correctly."
        
        if eloDelta >= 0 {
            resultsEloLabel.text = "+\(eloDelta) Elo Gained"
            resultsEloPill.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            resultsEloLabel.textColor = .systemGreen
        } else {
            resultsEloLabel.text = "\(eloDelta) Elo Rating"
            resultsEloPill.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            resultsEloLabel.textColor = .systemRed
        }
        
        resultsOverlayView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.resultsOverlayView.alpha = 1
        }
    }
    
    @objc private func finishTapped() {
        let didPass = (score >= (questions.count / 2))
        onQuizCompleted?(didPass)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeTapped() {
        let alert = UIAlertController(
            title: "Leave Arena?",
            message: "Your progress for this blitz round will not be saved.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Keep Coding", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
