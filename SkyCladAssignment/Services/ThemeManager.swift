//
//  ThemeManager.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = true
    
    static let shared = ThemeManager()
    
    private init() {
        // Load from UserDefaults
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
            // Default to dark mode if not set
            self.isDarkMode = true
        }
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
}

// MARK: - Theme Colors

extension Color {
    // Background Colors
    static var themeBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.black
                : UIColor.systemBackground
        })
    }
    
    static var themeSecondaryBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.systemGray6
                : UIColor.secondarySystemBackground
        })
    }
    
    // Text Colors
    static var themePrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.white
                : UIColor.label
        })
    }
    
    static var themeSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.systemGray
                : UIColor.secondaryLabel
        })
    }
    
    static var themeTertiary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.systemGray2
                : UIColor.tertiaryLabel
        })
    }
    
    // Card Colors
    static var themeCardBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.systemGray6.withAlphaComponent(0.3)
                : UIColor.systemBackground
        })
    }
    
    static var themeCardBorder: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.white.withAlphaComponent(0.1)
                : UIColor.systemGray4
        })
    }
}

// MARK: - Theme Modifier

struct ThemeModifier: ViewModifier {
    @StateObject private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            .environmentObject(themeManager)
    }
}

extension View {
    func themed() -> some View {
        self.modifier(ThemeModifier())
    }
}
