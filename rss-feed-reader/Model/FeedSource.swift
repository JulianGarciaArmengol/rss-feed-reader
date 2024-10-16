//
//  FeedSource.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 15/10/24.
//

import Foundation
import SwiftData

@Model
final class FeedSource: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var url: String
    
    init(name: String, url: String) {
        self.id = UUID()
        self.name = name
        self.url = url
    }
}
