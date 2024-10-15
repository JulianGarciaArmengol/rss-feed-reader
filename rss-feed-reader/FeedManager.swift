//
//  FeedManager.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 14/10/24.
//

import Foundation
import FeedKit

actor FeedManager {
    
    func fetchFeed() async throws {
        let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!
        
        
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                dump(feed)
            case .failure(let failure):
                print("ERROR: \(failure.localizedDescription)")
            }
        }
    }
}
