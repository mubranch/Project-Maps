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
    
    @State private var text : String = ""
    @State private var previewText: String = samplePreviewText.randomElement()!
    @State private var isShowingDetailView: Bool = false
    @State private var isShowingChat: Bool = false
    
    private let apiHandler = APIHandler()
    private let openAIService = OpenAIService()
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 60*60*24)
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    logo
                    if !isShowingChat {
                        prompt1
                        datePicker
                    } else {
                        prompt2
                    }

                }
                .frame(maxHeight: .infinity)
                if isShowingChat {
                    search
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#ffffff"))
            .toolbar {
                if isShowingChat {
                    Button("Edit Trip Dates") {
                        withAnimation {
                            isShowingChat.toggle()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: [.top, .bottom])
    }
    
    var logo: some View {
        ZStack {
            Image(systemName: "globe.europe.africa.fill")
                .font(.system(size: 180))
                .fontWeight(.ultraLight)
                .padding()
                .blur(radius: 0.2)
            
            Image(systemName: "airplane")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
                .padding()
        }
    }
    
    var datePicker: some View {
        HStack {
            DatePicker("Start Date", selection: $startDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .disabled(isShowingChat)
            
            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .disabled(isShowingChat)
            
            if !isShowingChat {
                Button {
                    withAnimation {
                        isShowingChat.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Circle())
                .padding(.vertical, 4)
            }
        }
        .padding()
    }
    
    var prompt1: some View {
        Text("When are you travelling?")
            .font(.title2)
            .minimumScaleFactor(0.6)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    var prompt2: some View {
        Text("Where are you going and what will you be doing there?")
            .font(.title2)
            .minimumScaleFactor(0.6)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    var search: some View {
        VStack {
            Spacer()
            HStack {
                HStack {
                    TextField("Tell us your secrets...", text: $text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.leading)
                    
                    Button {
                        Task {
                            text = ""
//                            await submitQuery(input: text)
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
                    .padding(.vertical, 4)
                }
                .background {
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(.white)
                }
            }
                
        }
        .padding()

    }
    
    private func submitQuery(input: String) async -> Void {
        // Set key before submitting query - fix later
        openAIService.setKey(key: apiHandler.openAIKey)
        
        let query = "Extract the activity, location, and month from the following text and return it format as json in response. Text: \(input)"
        let response = openAIService.query(prompt: "\(query)")
        print(response)
    }
}

#Preview("HomeView") {
    HomeView()
}
