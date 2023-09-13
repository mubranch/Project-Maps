//
//  BufferView.swift
//  PackList
//
//  Created by Mustafa on 9/13/23.
//

import SwiftUI

struct BufferView: View {
    private let openAIService = OpenAIService()
    let input : String
    @State private var isShowingDetailView: Bool = false
    @State private var response: [String: Any]? = nil
    @Binding var isShowingChat: Bool
    @State private var isLoading = true
    
    var body: some View {
        VStack {
                if response != nil {
                    if let dict = response {
                        if let activity = dict["activity"] as? String, let location = dict["location"] as? String {
                            Text("Activity: \(activity)")
                            Text("Location: \(location)")
                        } else {
                            Text("Unable to determine activity and location")
                        }
                    } else {
                        Text("Invalid JSON response")
                    }
                } else {
                    if isLoading {
                        ProgressView()
                    }
                }
            }
            .task {
                let group = DispatchGroup()
                group.enter()
                response = await submitQuery(input: input)
                group.notify(queue: .main, execute: {
                    isLoading = false
                })
            }
    }
    
    private func submitQuery(input: String) async -> [String: Any]? {
        // Set key before submitting query - fix later
        
        let query = "Extract the activity, and location from the following text and return as json in response. If you can't determine both the activity and location from the provided string, return an error. Text: \(input)."
        let response = try? await openAIService.query(prompt: "\(query)")
        print(response ?? "No response")
        return response
    }

    private func convertToDictionary(_ jsonString: String) -> [String: String]? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                // Deserialize JSON data into a dictionary
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                    return dictionary
                }
            } catch {
                print("Failed to convert JSON data: \(error)")
            }
        }
        return nil
    }

}

#Preview {
    BufferView(input: "Backpacking in Death Valley", isShowingChat: .constant(true))
}
