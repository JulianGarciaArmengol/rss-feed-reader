//
//  FeedsSheetView.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 15/10/24.
//

import SwiftUI
import SwiftData

struct FeedsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var feedsViewModel: FeedsViewModel
    
    @State private var showingAlert = false
    @State private var name = ""
    @State private var url = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(feedsViewModel.feedSources, id: \.self) { feedSource in
                    VStack(alignment: .leading) {
                        Text(feedSource.name)
                            .font(.title2)
                        Text(feedSource.url)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Feed Sources")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", role: .cancel) { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { showingAlert = true }
                }
            }
        }
        .alert("New Feed", isPresented: $showingAlert) {
            TextField("Enter feed name", text: $name)
            TextField("Enter feed url", text: $url)
            
            Button("Cancel", role: .cancel) {}
            
            Button("Add") {
                guard !name.isEmpty && !url.isEmpty else {
                    return
                }
                
                feedsViewModel.addFeedSource(name: name, url: url)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        let feedSource = feedsViewModel.feedSources[offsets.first!]
        feedsViewModel.removeFeedSource(feedSource)
    }
}

#Preview {
    let container: ModelContainer = {
        do {
            return try ModelContainer(for: FeedSource.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }()
    
    FeedsSheetView(
        feedsViewModel: FeedsViewModel(modelContext: container.mainContext)
    )
}
