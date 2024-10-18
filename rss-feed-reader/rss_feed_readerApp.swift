//
//  rss_feed_readerApp.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 14/10/24.
//

import SwiftUI
import SwiftData



@main
struct rss_feed_readerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FeedSource.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var userPreferences = UserPreferences()
    
    var body: some Scene {
        WindowGroup {
            FeedsView(modelContext: sharedModelContainer.mainContext)
                .preferredColorScheme(userPreferences.colorScheme)
        }
        .environmentObject(userPreferences)
        .modelContainer(sharedModelContainer)
    }
}
