//
//  FeedItem.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 17/10/24.
//

import Foundation
import FeedKit

struct FeedItem: Identifiable, Hashable, Encodable {
    let id: String
    let title: String
    let link: String
    let description: String
    let image: String?
    let date: Date
    
    let source: String
}

extension FeedItem {
    init(_ entry: AtomFeedEntry, from source: String) {
        id = entry.id ?? UUID().uuidString
        title = entry.title ?? ""
        link = entry.links?.first?.attributes?.href ?? ""
        description = entry.summary?.value ?? ""
        image = entry.media?.mediaThumbnails?.first?.attributes?.url
        date = entry.published ?? .now
        
        self.source = source
    }
    
    init(_ item: JSONFeedItem, from source: String) {
        id = item.id ?? UUID().uuidString
        title = item.title ?? ""
        link = item.url ?? ""
        description = item.summary ?? ""
        image = item.image
        date = item.datePublished ?? .now
        
        self.source = source
    }
    
    init(_ item: RSSFeedItem, from source: String) {
        id = item.guid?.value ?? UUID().uuidString
        title = item.title ?? ""
        link = item.link ?? ""
        description = item.description ?? ""
//        image = item.media?.mediaThumbnails?.first?.attributes?.url
        image = item.media?.mediaContents?.first?.attributes?.url
        date = item.pubDate ?? .now
        
        self.source = source
        
//        dump(item)
    }
}
