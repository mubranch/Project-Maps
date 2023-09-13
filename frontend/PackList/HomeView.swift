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
    @State private var isShowingBufferView: Bool = false
    @State private var isShowingChat: Bool = false
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
            .background(.white)
            .toolbar {
                if isShowingChat {
                    Button("Edit") {
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
        GeometryReader { proxy in
            ZStack {
                Color(hex:"#FE6B72")
                Image("globe")
                    .position(CGPoint(x:proxy.size.width/2, y:proxy.size.height*0.7))
                    .font(.system(size: proxy.size.width))
                    .fontWeight(.ultraLight)
                    .border(.red)
                    .shadow(radius: 5)
                    
                Image(systemName: "airplane")
                    .position(CGPoint(x:proxy.size.width*0.6, y:proxy.size.height*0.45))
                    .font(.system(size: proxy.size.width*0.5))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .shadow(radius: 3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .strokeBorder(.black, style: .init(lineWidth: 4))
            }
        }
        .frame(maxWidth: 200, maxHeight: 200)
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
                .buttonStyle(.bordered)
                .background(Color(hex:"#FE6B72"))
                .foregroundStyle(.white)
                .clipShape(Circle())
                .padding(.vertical, 4)
            }
        }
        .padding()
    }
    
    var prompt1: some View {
        Text("When is your trip?")
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
            Divider()
            HStack {
                HStack {
                    TextField("Tell us your secrets...", text: $text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.leading)
                    
                    Button {
                        Task {
                            isShowingBufferView = true
                        }
                    } label: {
                        Image(systemName: "arrow.up")
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .background(text == "" ? Color(uiColor: .systemGray) : Color(hex:"#FE6B72"))
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .disabled(text == "")
                    .navigationDestination(isPresented: $isShowingBufferView, destination: {
                        BufferView(input: text, isShowingChat: $isShowingChat)
                    })
                }
            }
            .padding()
        }

    }
    
    
}

#Preview("HomeView") {
    HomeView()
}
