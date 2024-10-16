//
//  FeedsViewModel.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 15/10/24.
//

import Foundation
import SwiftData

@Observable
final class FeedsViewModel {
    private let feedManager: FeedManager
    private var modelContext: ModelContext
    
    var feedSources = [FeedSource]()
    var feedItems = [String]()
    
    init(
        feedManager: FeedManager = FeedManager(),
        modelContext: ModelContext
    ) {
        self.feedManager = feedManager
        self.modelContext = modelContext
        
        fetchFeedSources()
    }
    
    func fetchFeeds() {
        Task(priority: .userInitiated) {
            
            var allItems = [String]()
            
            for feedSource in feedSources {
                do {
                    let feed = try await feedManager.fetchFeed(url: feedSource.url)
                    
                    allItems.append(contentsOf: feed)
                } catch {
                    print("Error fetching feed: \(error.localizedDescription)")
                }
            }
            
            await MainActor.run { [allItems] in
                // TODO: sort by date
                
                self.feedItems = allItems
            }
        }
    }
    
    func fetchFeedSources() {
        do {
            let descriptor = FetchDescriptor<FeedSource>()
            feedSources = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func addFeedSource(name: String, url: String) {
        let feedSource = FeedSource(name: name, url: url)
        modelContext.insert(feedSource)
        
        fetchFeedSources()
    }
    
    func removeFeedSource(_ feedSource: FeedSource) {
        modelContext.delete(feedSource)
        
        do {
            try modelContext.save()
        } catch {
            print("error saving context: \(error.localizedDescription)")
        }
        
        fetchFeedSources()
    }
}
