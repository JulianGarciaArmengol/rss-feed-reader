//
//  ItemDetailsView.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 17/10/24.
//

import SwiftUI

struct ItemDetailsView: View {
    
    var item: FeedItem
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    @State var showBottomSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(item.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Optional Image
                if let imageUrl = item.image, let url = URL(string: imageUrl) {
                    VStack(alignment: .center) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .frame(minHeight: 250, maxHeight: 500)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Description
                Text(item.description)
                    .font(userPreferences.selectedFont)
//                    .font(Font.custom("Caveat", size: 18))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Date
                Text("Published on: \(formattedDate(item.date))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .padding()
        }
        .sheet(isPresented: $showBottomSheet) {
            UserPreferencesView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Configuration", systemImage: "gear") {
                    showBottomSheet = true
                }
            }
            
            if let url = URL(string: item.link) {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: url)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Link(destination: url) {
                        Label {
                            Text("Open in safari")
                        } icon: {
                            Image(systemName: "safari")
                        }
                    }
                }
            }
        }
    }

    
    // Helper function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        ItemDetailsView(
            item: .init(
                id: "123123123",
                title: "Title",
                link: "https://google.com",
                description: "This is the description",
                image: nil,
                date: .now,
                source: "por acaa"
            )
        )
    }
}
