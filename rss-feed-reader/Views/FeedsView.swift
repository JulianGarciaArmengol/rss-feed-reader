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
            ZStack {
                List(viewModel.feedItems, id: \.self) { item in
                    NavigationLink(value: item) {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(3)
                            
                            HStack {
                                Text(
                                    item.source + " - " + item.date.formatted()
                                )
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                                .lineLimit(1)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchFeeds()
                }
                .navigationDestination(for: FeedItem.self) { item in
                    ItemDetailsView(item: item)
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
                
                if viewModel.feedSources.isEmpty {
                    Text("Add sources to start reading!")
                }
            }
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
