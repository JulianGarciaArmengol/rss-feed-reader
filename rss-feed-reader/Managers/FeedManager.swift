//
//  FeedManager.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 14/10/24.
//

import Foundation
import FeedKit

/**
 http://images.apple.com/main/rss/hotnews/hotnews.rss
 https://www.xataka.com/feedburner.xml
 */

enum FeedManagerError: Error {
    case invalidURL
    case invalidFeed
    case noItems
}

class FeedManager {
    
    func fetchFeed(url: String, from source: String) async throws -> [FeedItem] {
        let trimmedUrl = url.trimmingCharacters(in: .whitespaces)

        guard let feedURL = URL(string: trimmedUrl) else {
            throw FeedManagerError.invalidURL
        }
        
        let parser = FeedParser(URL: feedURL)
        
        return try await withCheckedThrowingContinuation { continuation in
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
                
                switch result {
                case .success(let feed):
                    if let feed = feed.atomFeed {
                        print("atom feed")
                        
                        guard let entries = feed.entries else {
                            continuation.resume(throwing: FeedManagerError.noItems)
                            return
                        }
                        
                        let feedItems = entries.compactMap { entry in
                            FeedItem(entry, from: source)
                        }
                        
                        continuation.resume(returning: feedItems)
                        
                    } else if let feed = feed.jsonFeed {
                        print("json feed")
                        
                        guard let items = feed.items else {
                            continuation.resume(throwing: FeedManagerError.noItems)
                            return
                        }
                        
                        let feedItems = items.compactMap { item in
                            FeedItem(item, from: source)
                        }
                        
                        continuation.resume(returning: feedItems)
                        
                    } else if let feed = feed.rssFeed {
                        print("rss feed")
                        
                        guard let items = feed.items else {
                            continuation.resume(throwing: FeedManagerError.noItems)
                            return
                        }
                        
                        let feedItems = items.compactMap { item in
                            FeedItem(item, from: source)
                        }
                        
                        continuation.resume(returning: feedItems)
                    } else {
                        continuation.resume(throwing: FeedManagerError.invalidFeed)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
