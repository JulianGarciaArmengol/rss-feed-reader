//
//  SelectedColorScheme.swift
//  rss-feed-reader
//
//  Created by julian.garcia on 17/10/24.
//

import SwiftUI

enum CustomFonts: String, CaseIterable, Codable {
    case system = "System"
    case caveat = "Caveat"
    case montserrat = "Montserrat"
}

class UserPreferences: ObservableObject {
    @Published var colorScheme: ColorScheme {
        didSet {
            UserDefaults.standard.set(colorScheme == .dark ? true : false, forKey: "DARK_MODE")
        }
    }
    
    @Published var isDarkScheme: Bool = false {
        didSet {
            colorScheme = isDarkScheme ? .dark : .light
        }
    }
    
    let fontSizes = [8, 16, 24, 32]
    
    @Published var selectedFontSize: Int = 16 {
        didSet {
            updateFont()
        }
    }
    @Published var selectedFontFamily: CustomFonts = .system {
        didSet {
            updateFont()
        }
    }
    
    @Published var selectedFont: Font = .system(size: 16)
    
    init() {
        if UserDefaults.standard.bool(forKey: "DARK_MODE") {
            colorScheme = .dark
        } else {
            colorScheme = .light
        }
    }
    
    func setDarkScheme(_ isDark: Bool) {
        withAnimation {
            colorScheme = isDark ? .dark : .light
        }
    }
    
    
    func setFont(_ font: CustomFonts, size: CGFloat) {
        selectedFont = switch font {
        case .system:
                .system(size: size)
        case .caveat:
                .custom("Caveat", size: size)
        case .montserrat:
                .custom("Montserrat", size: size)
        }
    }
    
    func updateFont() {
        let size = CGFloat(selectedFontSize)
        
        selectedFont = switch selectedFontFamily {
        case .system:
                .system(size: size)
        case .caveat:
                .custom("Caveat", size: size)
        case .montserrat:
                .custom("Montserrat", size: size)
        }
    }
}
