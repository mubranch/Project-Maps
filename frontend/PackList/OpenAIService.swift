//
//  OpenAIService.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//

//
//  OpenAIService.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//

import Foundation

class OpenAIService {
    
    private let apiHandler = APIHandler()
    private var apiUrl = "https://api.openai.com/v1/chat/completions" // You may need to adjust the API URL based on OpenAI's current endpoint.
    
    var apiKey: String {
        apiHandler.openAIKey
    }

    func setURL(url: String) {
        self.apiUrl = url
    }

    func query(prompt: String) async throws -> [String: Any]? {
        if self.apiKey == "" {
            throw NSError(domain: "OpenAI API Key is missing", code: 0, userInfo: nil)
        }

        let responseData = try await sendRequest(prompt: prompt)

        if let message = parseResponse(responseData) {
            print(message)
            return message
        } else {
            throw NSError(domain: "Failed to extract message from response.", code: 0, userInfo: nil)
        }
    }

    private func sendRequest(prompt: String) async throws -> Data {
        guard let apiUrl = URL(string: apiUrl) else {
            throw NSError(domain: "Invalid API URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        // Set the Authorization header with your API key
        let apiKeyHeader = "Bearer \(apiKey)"
        request.setValue(apiKeyHeader, forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestData: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": "\(prompt)"]],
            "temperature": 0.7,
            "max_tokens": 500 // You can adjust as needed
        ]

        do {
            let jsonRequestData = try JSONSerialization.data(withJSONObject: requestData, options: [])
            request.httpBody = jsonRequestData
        } catch {
            throw error
        }

        let (data, _) = try await URLSession.shared.data(from: request)

        return data
    }

    private func parseResponse(_ responseData: Data) -> [String: Any]? {
        // Parse the JSON response data
        if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
            print(jsonObject)
           return jsonObject
        } else {
            return nil
        }
    }
}
