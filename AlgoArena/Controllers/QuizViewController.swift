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
    
    // UI Connections
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
    }
    
    func loadQuestion() {
        // Prevent crashing if no questions exist
        guard currentQuestionIndex < questions.count else { return }
        
        let current = questions[currentQuestionIndex]
        
        // Native decoding for HTML entities like &quot;
        guard let decodedData = current.question.data(using: .utf8) else { return }
        let decodedQuestion = try? NSAttributedString(data: decodedData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        
        questionLabel.text = decodedQuestion ?? current.question
        
        // Populate the 4 buttons
        let options = current.shuffledAnswers
        option1Button.setTitle(options[0], for: .normal)
        option2Button.setTitle(options[1], for: .normal)
        option3Button.setTitle(options[2], for: .normal)
        option4Button.setTitle(options[3], for: .normal)
    }
    
    // All 4 buttons will trigger this exact same function
    @IBAction func optionTapped(_ sender: UIButton) {
        print("User tapped an answer!")
        // We will add the gamification and scoring logic here next
    }
}
