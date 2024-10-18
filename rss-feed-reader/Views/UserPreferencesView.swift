//
//  UserPreferencesView.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 18/10/24.
//

import SwiftUI

struct UserPreferencesView: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
         
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Toggle("Dark theme", isOn: $userPreferences.isDarkScheme)
            }
            
            VStack(alignment: .leading) {
                Text("Font Size")
                Picker("Font Size", selection: $userPreferences.selectedFontSize) {
                    ForEach(userPreferences.fontSizes, id: \.self) { fontSize in
                        Text("\(fontSize)")
                    }
                }
                
            }
            
            VStack(alignment: .leading) {
                Text("Font style")
                Picker("Font Style", selection: $userPreferences.selectedFontFamily) {
                    ForEach(CustomFonts.allCases, id: \.self) { font in
                        Text(font.rawValue)
                    }
                }
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

#Preview {
    UserPreferencesView()
        .environmentObject(UserPreferences())
    
}
