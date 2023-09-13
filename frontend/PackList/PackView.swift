//
//  PackView.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//

import SwiftUI

struct PackView: View {
    
    let items : [String:Int]
    
    @State private var selectedItems: Dictionary<String, Bool> = [:]
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                Image(systemName: "suitcase.rolling.fill")
                    .font(.system(size: 96))
                Text(getSuitcaseWeight().formatted())
                    .font(.title)
            }
            .padding(.vertical)
            
            Text("Reccommended packing list")
                .fontWeight(.semibold)
                .padding()
            
            List(Array(items.enumerated()), id: \.offset) { item in
                let itemName = item.element.key
                let itemWeight = Measurement<UnitMass>(value: Double(item.element.value), unit: .grams)
                
                ClothingItem(itemName: itemName, itemWeight: itemWeight.formatted(), selectedItems: $selectedItems)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Some Name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button{} label: { Image(systemName: "square.and.arrow.up") }
            }
        }
        .padding(.horizontal)
        .onAppear {
            for clothingItem in items.keys {
                selectedItems[clothingItem] = false
            }
        }
    }
    
    private func getSuitcaseWeight() -> Measurement<UnitMass> {
        var weight : Double = 0
        let items = selectedItems.filter({ $0.value })
        for item in items {
            weight += Double(clothingItems[item.key] ?? 0)
        }
        return Measurement<UnitMass>(value: weight, unit: .grams)
    }
    
    struct UncheckedBox: View {
        var body: some View {
            VStack {
                Circle()
                    .fill(Color.white)
                    .stroke(.tertiary, style: .init())
            }
            .frame(width: 20, height: 20)
            .padding(.trailing)
        }
    }
    
    struct CheckedBox: View {
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color(hex:"#FE6B72"))
                }
            }
            .frame(width: 20, height: 20)
            .padding(.trailing)
        }
    }
    
    struct ClothingItem: View {
        let itemName: String
        let itemWeight: String
        @State private var isChecked = false
        @Binding var selectedItems : Dictionary<String, Bool>
        
        var body: some View {
            HStack {
                VStack {
                    if isChecked {
                        CheckedBox()
                    } else {
                        UncheckedBox()
                    }
                }.onTapGesture {
                    isChecked.toggle()
                    selectedItems[itemName] = isChecked
                }
                
                HStack {
                    Text(itemName)
                    Spacer()
                    Text(itemWeight)
                }
                .foregroundStyle(isChecked ? .primary : .secondary)
            }
        }
    }
}

#Preview("PackView") {
    
    let previewItems: [String: Int] = [
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
    
    return PackView(items: previewItems)
}
