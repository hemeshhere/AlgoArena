//
//  OnboardingViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 22/10/26.
//

import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {

    // Storyboard outlets kept for storyboard compatibility
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var difficultySegment: UISegmentedControl!

    // Modern Responsive Layout Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoBadgeView = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let taglineLabel = UILabel()
    
    private let featuresStackView = UIStackView()
    private let cardContainerView = UIView()
    private let handlePromptLabel = UILabel()
    private let customTextField = UITextField()
    private let tierPromptLabel = UILabel()
    private let customDifficultySegment = UISegmentedControl(items: ["Beginner", "Intermediate"])
    private let difficultyHelpLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupModernLayout()
        setupKeyboardDismissal()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GameEngine.shared.username.isEmpty {
            goToDashboard()
        }
    }

    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupModernLayout() {
        // Hide or re-parent storyboard elements if needed
        usernameTextField?.isHidden = true
        difficultySegment?.isHidden = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Hero Logo Badge
        logoBadgeView.translatesAutoresizingMaskIntoConstraints = false
        logoBadgeView.layer.cornerRadius = 24
        logoBadgeView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.15)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 42, weight: .bold)
        logoImageView.image = UIImage(systemName: "apple.terminal", withConfiguration: iconConfig)
        logoImageView.tintColor = .systemIndigo
        logoImageView.contentMode = .scaleAspectFit
        logoBadgeView.addSubview(logoImageView)

        // Title & Tagline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "AlgoArena"
        titleLabel.font = .systemFont(ofSize: 34, weight: .heavy)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center

        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.text = "Master Data Structures & Algorithms.\nBattle Bugs. Level Up Your Elo."
        taglineLabel.font = .systemFont(ofSize: 15, weight: .medium)
        taglineLabel.textColor = .secondaryLabel
        taglineLabel.textAlignment = .center
        taglineLabel.numberOfLines = 0

        // Features Stack
        featuresStackView.translatesAutoresizingMaskIntoConstraints = false
        featuresStackView.axis = .vertical
        featuresStackView.spacing = 8
        featuresStackView.alignment = .center

        let pill1 = createFeaturePill(icon: "bolt.fill", text: "Competitive Elo System", color: .systemBlue)
        let pill2 = createFeaturePill(icon: "flame.fill", text: "Daily Streak Tracking", color: .systemOrange)
        let pill3 = createFeaturePill(icon: "network", text: "Data Structure Blitzes", color: .systemGreen)
        featuresStackView.addArrangedSubview(pill1)
        featuresStackView.addArrangedSubview(pill2)
        featuresStackView.addArrangedSubview(pill3)

        // Setup Card
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.backgroundColor = .secondarySystemGroupedBackground
        cardContainerView.layer.cornerRadius = 22
        cardContainerView.layer.borderWidth = 1
        cardContainerView.layer.borderColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        cardContainerView.layer.shadowColor = UIColor.black.cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainerView.layer.shadowRadius = 12
        cardContainerView.layer.shadowOpacity = 0.06

        handlePromptLabel.translatesAutoresizingMaskIntoConstraints = false
        handlePromptLabel.text = "CODER HANDLE"
        handlePromptLabel.font = .systemFont(ofSize: 12, weight: .bold)
        handlePromptLabel.textColor = .secondaryLabel

        // Custom Text Field
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Enter your handle (e.g. neo_dev)"
        customTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        customTextField.backgroundColor = .tertiarySystemGroupedBackground
        customTextField.layer.cornerRadius = 14
        customTextField.autocorrectionType = .no
        customTextField.autocapitalizationType = .none
        customTextField.returnKeyType = .done
        customTextField.delegate = self
        customTextField.clearButtonMode = .whileEditing
        
        let leftIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 48))
        let leftIcon = UIImageView(image: UIImage(systemName: "at"))
        leftIcon.tintColor = .secondaryLabel
        leftIcon.frame = CGRect(x: 12, y: 14, width: 20, height: 20)
        leftIconContainer.addSubview(leftIcon)
        customTextField.leftView = leftIconContainer
        customTextField.leftViewMode = .always

        tierPromptLabel.translatesAutoresizingMaskIntoConstraints = false
        tierPromptLabel.text = "STARTING LEVEL"
        tierPromptLabel.font = .systemFont(ofSize: 12, weight: .bold)
        tierPromptLabel.textColor = .secondaryLabel

        // Segmented Control
        customDifficultySegment.translatesAutoresizingMaskIntoConstraints = false
        customDifficultySegment.selectedSegmentIndex = 0
        customDifficultySegment.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)

        difficultyHelpLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyHelpLabel.text = "Beginner: Starts at 1200 Elo rating"
        difficultyHelpLabel.font = .systemFont(ofSize: 12, weight: .medium)
        difficultyHelpLabel.textColor = .tertiaryLabel
        difficultyHelpLabel.textAlignment = .center

        // Action Button
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("Enter the Arena ⚔️", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        actionButton.backgroundColor = .systemIndigo
        actionButton.tintColor = .white
        actionButton.layer.cornerRadius = 16
        actionButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        actionButton.layer.shadowRadius = 8
        actionButton.layer.shadowOpacity = 0.3
        actionButton.addTarget(self, action: #selector(startCodingTapped(_:)), for: .touchUpInside)

        // Wire outlets
        usernameTextField = customTextField
        difficultySegment = customDifficultySegment

        // Hierarchy
        contentView.addSubview(logoBadgeView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(featuresStackView)
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(handlePromptLabel)
        cardContainerView.addSubview(customTextField)
        cardContainerView.addSubview(tierPromptLabel)
        cardContainerView.addSubview(customDifficultySegment)
        cardContainerView.addSubview(difficultyHelpLabel)
        contentView.addSubview(actionButton)

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

            // Logo
            logoBadgeView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 28),
            logoBadgeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoBadgeView.widthAnchor.constraint(equalToConstant: 80),
            logoBadgeView.heightAnchor.constraint(equalToConstant: 80),

            logoImageView.centerXAnchor.constraint(equalTo: logoBadgeView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoBadgeView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 44),
            logoImageView.heightAnchor.constraint(equalToConstant: 44),

            // Title
            titleLabel.topAnchor.constraint(equalTo: logoBadgeView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            taglineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            taglineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Features Stack
            featuresStackView.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 20),
            featuresStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Card
            cardContainerView.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 24),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            handlePromptLabel.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 20),
            handlePromptLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 18),

            customTextField.topAnchor.constraint(equalTo: handlePromptLabel.bottomAnchor, constant: 8),
            customTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 18),
            customTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -18),
            customTextField.heightAnchor.constraint(equalToConstant: 50),

            tierPromptLabel.topAnchor.constraint(equalTo: customTextField.bottomAnchor, constant: 20),
            tierPromptLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 18),

            customDifficultySegment.topAnchor.constraint(equalTo: tierPromptLabel.bottomAnchor, constant: 8),
            customDifficultySegment.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 18),
            customDifficultySegment.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -18),
            customDifficultySegment.heightAnchor.constraint(equalToConstant: 36),

            difficultyHelpLabel.topAnchor.constraint(equalTo: customDifficultySegment.bottomAnchor, constant: 8),
            difficultyHelpLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 18),
            difficultyHelpLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -18),
            difficultyHelpLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -20),

            // Action Button
            actionButton.topAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: 24),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 54),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func createFeaturePill(icon: String, text: String, color: UIColor) -> UIView {
        let pill = UIView()
        pill.translatesAutoresizingMaskIntoConstraints = false
        pill.backgroundColor = color.withAlphaComponent(0.12)
        pill.layer.cornerRadius = 14

        let iconIV = UIImageView(image: UIImage(systemName: icon))
        iconIV.translatesAutoresizingMaskIntoConstraints = false
        iconIV.tintColor = color
        iconIV.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = color

        pill.addSubview(iconIV)
        pill.addSubview(label)

        NSLayoutConstraint.activate([
            pill.heightAnchor.constraint(equalToConstant: 28),
            iconIV.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 10),
            iconIV.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            iconIV.widthAnchor.constraint(equalToConstant: 14),
            iconIV.heightAnchor.constraint(equalToConstant: 14),

            label.leadingAnchor.constraint(equalTo: iconIV.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor)
        ])

        return pill
    }

    @objc private func difficultyChanged() {
        if customDifficultySegment.selectedSegmentIndex == 1 {
            difficultyHelpLabel.text = "Intermediate: Starts at 1400 Elo rating"
        } else {
            difficultyHelpLabel.text = "Beginner: Starts at 1200 Elo rating"
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startCodingTapped(actionButton)
        return true
    }

    @IBAction func startCodingTapped(_ sender: UIButton) {
        guard let name = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            let alert = UIAlertController(
                title: "Missing Handle",
                message: "Please enter a valid coder handle to enter the Arena.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Got It", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        GameEngine.shared.username = name
        GameEngine.shared.eloRating = difficultySegment.selectedSegmentIndex == 1 ? 1400 : 1200
        
        goToDashboard()
    }
    
    func goToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}
