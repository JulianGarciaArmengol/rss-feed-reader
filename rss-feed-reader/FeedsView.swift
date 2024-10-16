//
//  ContentView.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 14/10/24.
//

import SwiftUI

struct FeedsView: View {
    
    @State private var feed: [String] = ["1", "2", "3", "4", "5"]
    
    private var feedManager = FeedManager()
    
    var body: some View {
        NavigationStack {
            List(feed, id: \.self) { item in
                NavigationLink(item, value: item)
            }
            .navigationDestination(for: String.self) { item in
                Text(item)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Refresh")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Feeds")
                }
            }
            .navigationTitle("NeoFeed")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                let titles = try! await feedManager.fetchFeed(
                    url: "https://www.xataka.com/feedburner.xml"
                )
                
                print(titles)
            }
        }
    }
}

#Preview {
    FeedsView()
}
