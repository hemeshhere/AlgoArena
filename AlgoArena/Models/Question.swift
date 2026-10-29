//
//  Question.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 22/10/26.
//

import Foundation

struct TriviaResponse: Codable, Sendable {
    let response_code: Int
    let results: [Question]
}

struct Question: Codable, Sendable {
    let category: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    // Helper to get all options mixed up for the UI
    var shuffledAnswers: [String] {
        var all = incorrect_answers
        all.append(correct_answer)
        return all.shuffled()
    }
}
