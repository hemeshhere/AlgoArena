//
//  NetworkManager.swift
//  AlgoArena
//
//  Created by Hemesh Raj on 23/10/26.
//

import Foundation

class NetworkManager {
    // Singleton instance
    static let shared = NetworkManager()
    private init() {}
    
    // Fetches 5 multiple-choice Computer Science questions
    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&category=18&type=multiple"
        
        guard let url = URL(string: urlString) else { return }
        
        // This is the native iOS way to make an API call
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // 1. Check for network errors
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            // 2. Ensure data exists
            guard let data = data else { return }
            
            // 3. Parse the JSON into our Swift struct
            do {
                let decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume() 
    }
}
