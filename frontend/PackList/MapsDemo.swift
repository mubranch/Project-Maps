//
//  MapsDemo.swift
//  PackList
//
//  Created by Mustafa on 9/11/23.
//
import SwiftUI
import MapKit

class LocationAutocompleteViewModel: NSObject, ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    private var completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.resultTypes = .address
        completer.delegate = self
    }
    
    func fetchResults() {
        completer.queryFragment = searchQuery
    }
}

extension LocationAutocompleteViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.filter({
            !$0.title.contains("St") &&
            !$0.title.contains("Ln") &&
            !$0.title.contains("Rd") &&
            !$0.title.contains("Dr") &&
            !$0.title.contains("Ct") &&
            $0.title.contains("Ave") &&
            !$0.title.contains("Way")})
    }
}

struct LocationAutocompleteView: View {
    @StateObject private var viewModel = LocationAutocompleteViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter location", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                Text(viewModel.searchResults.first?.title ?? "")
            }
        }
        .navigationBarTitle("Location Autocomplete")
        .onChange(of: viewModel.searchQuery) { _ in
            viewModel.fetchResults()
        }
    }
}

struct LocationAutocompleteView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAutocompleteView()
    }
}



#Preview {
    LocationAutocompleteView()
}
