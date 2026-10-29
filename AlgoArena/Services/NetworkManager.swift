//
//  NetworkManager.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import Foundation

final class NetworkManager: @unchecked Sendable {
    // Singleton instance
    static let shared = NetworkManager()
    private init() {}
    
    // Curated offline algorithmic trivia questions for reliable practice
    private let fallbackQuestions: [Question] = [
        Question(
            category: "Algorithms",
            difficulty: "medium",
            question: "What is the worst-case time complexity of QuickSort?",
            correct_answer: "O(n²)",
            incorrect_answers: ["O(n log n)", "O(log n)", "O(n)"]
        ),
        Question(
            category: "Data Structures",
            difficulty: "easy",
            question: "Which data structure operates on a Last-In, First-Out (LIFO) basis?",
            correct_answer: "Stack",
            incorrect_answers: ["Queue", "Binary Tree", "Linked List"]
        ),
        Question(
            category: "Algorithms",
            difficulty: "medium",
            question: "What data structure does Breadth-First Search (BFS) typically use for graph traversal?",
            correct_answer: "Queue",
            incorrect_answers: ["Stack", "Priority Queue", "Min-Heap"]
        ),
        Question(
            category: "Data Structures",
            difficulty: "medium",
            question: "What is the average lookup time complexity in a balanced Hash Table?",
            correct_answer: "O(1)",
            incorrect_answers: ["O(log n)", "O(n)", "O(n log n)"]
        ),
        Question(
            category: "Complexity Theory",
            difficulty: "hard",
            question: "What is the minimum height of a balanced binary search tree with n nodes?",
            correct_answer: "O(log n)",
            incorrect_answers: ["O(n)", "O(1)", "O(n log n)"]
        )
    ]
    
    // Fetches 5 multiple-choice Computer Science questions with offline fallback
    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&category=18&type=multiple"
        
        guard let url = URL(string: urlString) else {
            completion(.success(fallbackQuestions.shuffled()))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 6.0
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Network request failed: \(error.localizedDescription). Using curated questions.")
                    completion(.success(self.fallbackQuestions.shuffled()))
                    return
                }
                
                guard let data = data else {
                    completion(.success(self.fallbackQuestions.shuffled()))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
                    if decodedData.results.isEmpty {
                        completion(.success(self.fallbackQuestions.shuffled()))
                    } else {
                        completion(.success(decodedData.results))
                    }
                } catch {
                    print("Decoding failed: \(error.localizedDescription). Falling back to curated questions.")
                    completion(.success(self.fallbackQuestions.shuffled()))
                }
            }
        }.resume()
    }
}
