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

struct FeedItem: Identifiable, Hashable, Encodable {
    let id: String
    let title: String
    let link: String
//    let subtitle: String?
//    let image: String?
    let date: Date
}

class FeedManager {
    
    func fetchFeed(url: String) async throws -> [String] {
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
                        
                        let entriesTitles = entries.compactMap(\.title)
                        
                        continuation.resume(returning: entriesTitles)
                        
                    } else if let feed = feed.jsonFeed {
                        print("json feed")
                        
                        guard let items = feed.items else {
                            continuation.resume(throwing: FeedManagerError.noItems)
                            return
                        }
                        
                        let itemsTitles = items.compactMap(\.title)
                        
                        continuation.resume(returning: itemsTitles)
                        
                    } else if let feed = feed.rssFeed {
                        print("rss feed")
                        
                        guard let items = feed.items else {
                            continuation.resume(throwing: FeedManagerError.noItems)
                            return
                        }
                        
                        let itemsTitles = items.compactMap(\.title)
                        
                        continuation.resume(returning: itemsTitles)
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
