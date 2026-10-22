//  OnboardingViewController.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 22/10/26.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
            super.viewDidLoad()
            // Leave this empty for now.Removed the goToDashboard() check from here.
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // Now it is safe to transition because the screen is fully mounted
            if !GameEngine.shared.username.isEmpty {
                print("User already exists: \(GameEngine.shared.username)")
                goToDashboard()
            }
        }

    @IBAction func startCodingTapped(_ sender: UIButton) {
        guard let name = usernameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else {
            print("Name is empty!")
            return
        }

        GameEngine.shared.username = name
        print("Saved username: \(GameEngine.shared.username)")

        goToDashboard()

    }

    func goToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let tabBarVC = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController"
        ) as? UITabBarController {

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {

                window.rootViewController = tabBarVC

                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: nil,
                    completion: nil
                )
            }
        }
    }
}
