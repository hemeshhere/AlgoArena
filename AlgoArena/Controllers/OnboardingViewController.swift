//
//  OnboardingViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 22/10/26.
//

import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var difficultySegment: UISegmentedControl!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GameEngine.shared.username.isEmpty {
            goToDashboard()
        }
    }

    // MARK: - Actions
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
        GameEngine.shared.eloRating = (difficultySegment.selectedSegmentIndex == 1) ? 1400 : 1200

        goToDashboard()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startCodingTapped(UIButton())
        return true
    }

    // MARK: - Navigation
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
