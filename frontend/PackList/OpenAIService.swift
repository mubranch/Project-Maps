//
//  OpenAIService.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//

import Foundation

class OpenAIService {
    private var apiKey = ""
    private var apiUrl = "https://api.openai.com/v1/chat/completions" // You may need to adjust the API URL based on OpenAI's current endpoint.
    
    func setKey(key: String) {
        self.apiKey = key
    }
    
    func setURL(url: String) {
        self.apiUrl = url
    }
    
    func query(prompt: String) -> String {
        
        if self.apiKey == "" {
            print("Failed to query OpenAI, missing API Key")
            return "Error: Set apiKey"
        }
        
        var response : String = ""
        
        sendRequest(prompt: prompt) { result in
            switch result {
            case .success(let responseData):
                // Convert the response data to a string
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response from OpenAI: \(responseString)")
                    response = responseString
                    
                    // Use the responseString
                } else {
                    print("Failed to convert response data to string.")
                }
            case .failure(let error):
                response = "Error: \(error)"
            }
        }
        return response
    }

    private func sendRequest(prompt: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let apiUrl = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid API URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestData: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role":"user", "content":"\(prompt)"]],
            "temperature": 0.7,
            "max_tokens": 500 // You can adjust as needed
        ]

        do {
            let jsonRequestData = try JSONSerialization.data(withJSONObject: requestData, options: [])
            request.httpBody = jsonRequestData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
