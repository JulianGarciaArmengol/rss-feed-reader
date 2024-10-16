//
//  ContentView.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 14/10/24.
//

import SwiftUI
import SwiftData

struct FeedsView: View {
    
    @State private var viewModel: FeedsViewModel
        
    @State private var showFeedsSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.feedItems, id: \.self) { item in
                NavigationLink(item, value: item)
            }
            .refreshable {
                viewModel.fetchFeeds()
            }
            .navigationDestination(for: String.self) { item in
                Text(item)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Refresh") {
                        viewModel.fetchFeeds()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Feeds") {
                        showFeedsSheet = true
                    }
                }
            }
            .navigationTitle("NeoFeed")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showFeedsSheet) {
            FeedsSheetView(feedsViewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchFeeds()
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = FeedsViewModel(modelContext: modelContext)
        
        _viewModel = State(initialValue: viewModel)
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
    
    FeedsView(modelContext: container.mainContext)
}
