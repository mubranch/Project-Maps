//
//  HomeView.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//

import SwiftUI

let savedtrips = ["Vacation in Cancun", "Hiking in Arizona", "Surfing in San Diego"]
let samplePreviewText = ["Vacation in Cancun","Camping in the Olympic Forest", "Climbing Yosemite", "Backpacking the Pacific Trail"]
let clothingItems: [String: Int] = [
       "T-shirt": 200,
       "Jeans": 500,
       "Shorts": 300,
       "Sweater": 600,
       "Hoodie": 700,
       "Underwear (pair)": 30,
       "Sock (pair)": 40,
       "Pajamas": 350,
       "Swimsuit": 250,
       "Jacket": 800,
       "Raincoat": 600,
       "Dress": 450,
       "Skirt": 350,
       "Suit (jacket)": 800,
       "Suit (pants)": 500,
       "Tie": 80,
       "Belt": 100,
       "Hat": 150,
       "Gloves (pair)": 60,
       "Scarf": 120,
       "Boot (pair)": 1200,
       "Sneaker (pair)": 800,
       "Sandal (pair)": 400
   ]

struct HomeView: View {
    
    @State private var textInput : String = ""
    @State private var previewText: String = samplePreviewText.randomElement()!
    @State private var isShowingDetailView: Bool = false
    
    private let openAIService = OpenAIService(apiKey: "")
    
    var body: some View {
        NavigationStack {
            ZStack {
                splash
                searchBar
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(edges: [.top, .bottom])
    }
    
    var splash: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Image(systemName: "tshirt.fill")
                .font(.system(size: 72))
            
            Text("Tell me where you're going, and what you're going to do there.")
                .font(.title2)
                .minimumScaleFactor(0.6)
                .lineLimit(3)
            
        }
        .padding()
    }
    
    var searchBar: some View {
        VStack {
            Spacer()
            HStack {
                TextField(previewText, text: $textInput)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .task {
                        // Start a timer to update previewText every 3 seconds
                        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { _ in
                            withAnimation {
                                previewText = samplePreviewText.randomElement()!
                            }
                        }
                    }
                    .padding(.leading)
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(.tertiary, style: .init())
                            .frame(minHeight: 32)
                    }
                
                Button {
                    Task {
                        textInput = ""
//                        await submitQuery()
                        isShowingDetailView = true
                    }
                } label: {
                    Image(systemName: "arrow.up")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Circle())
                .navigationDestination(isPresented: $isShowingDetailView, destination: {
                    PackView(items: clothingItems)
                })
            }
        }
        .padding()
    }
    
    private func submitQuery() async -> Void {
        let preamble = "Take on the perspective of someone going on a trip. Extract the activity and place from this query, and reccommend a list of items to pack. Items should fit inside a suitcase and carry-on. Take into account the historical weather for this location around the time of year when most people would visit. Site the temperature in fahrenheit. Only respond with the list, and weight of each item in grams."
        
        _ = openAIService.query(prompt: "\(preamble)")
    }
    
}

#Preview("HomeView") {
    HomeView()
}
