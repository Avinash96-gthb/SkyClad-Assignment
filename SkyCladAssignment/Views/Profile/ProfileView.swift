//
//  ProfileView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isLoggedIn = true
    @State private var notificationsEnabled = true
    @State private var biometricsEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                ProfileHeaderView()
                
                // Quick Stats
                QuickStatsView()
                
                // Settings Sections
                SettingsSectionView(
                    title: "Security",
                    items: [
                        SettingsItem(
                            icon: "faceid",
                            title: "Face ID / Touch ID",
                            hasToggle: true,
                            toggleValue: $biometricsEnabled
                        ),
                        SettingsItem(
                            icon: "key.fill",
                            title: "Change PIN",
                            action: { /* Handle change PIN */ }
                        ),
                        SettingsItem(
                            icon: "doc.text.fill",
                            title: "Recovery Phrase",
                            action: { /* Handle recovery phrase */ }
                        )
                    ]
                )
                
                SettingsSectionView(
                    title: "Preferences",
                    items: [
                        SettingsItem(
                            icon: "bell.fill",
                            title: "Notifications",
                            hasToggle: true,
                            toggleValue: $notificationsEnabled
                        ),
                        SettingsItem(
                            icon: "moon.fill",
                            title: "Dark Mode",
                            hasToggle: true,
                            toggleValue: $themeManager.isDarkMode
                        ),
                        SettingsItem(
                            icon: "globe",
                            title: "Language",
                            subtitle: "English",
                            action: { /* Handle language */ }
                        ),
                        SettingsItem(
                            icon: "dollarsign.circle.fill",
                            title: "Currency",
                            subtitle: "INR (₹)",
                            action: { /* Handle currency */ }
                        )
                    ]
                )
                
                SettingsSectionView(
                    title: "Support",
                    items: [
                        SettingsItem(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            action: { /* Handle help */ }
                        ),
                        SettingsItem(
                            icon: "envelope.fill",
                            title: "Contact Support",
                            action: { /* Handle contact */ }
                        ),
                        SettingsItem(
                            icon: "doc.fill",
                            title: "Terms & Privacy",
                            action: { /* Handle terms */ }
                        )
                    ]
                )
                
                // Logout Button
                LogoutButton {
                    // Handle logout
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .background(Color.themeBackground)
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Profile Picture
            Button(action: {
                // Handle profile picture change
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Text("AC")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Edit icon
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                        )
                        .offset(x: 28, y: 28)
                }
            }
            
            VStack(spacing: 4) {
                Text("Avinash Chidambaram")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.themePrimary)
                
                Text("avinash@example.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Verification Badge
            HStack(spacing: 8) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text("Verified Account")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.2))
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.indigo.opacity(0.4),
                            Color.purple.opacity(0.3),
                            Color.blue.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct QuickStatsView: View {
    var body: some View {
        HStack {
            QuickStatCard(
                title: "Total Trades",
                value: "247",
                icon: "arrow.2.squarepath",
                color: .blue
            )
            
            QuickStatCard(
                title: "This Month",
                value: "₹45,230",
                icon: "chart.line.uptrend.xyaxis",
                color: .green
            )
            
            QuickStatCard(
                title: "Rewards",
                value: "₹1,250",
                icon: "star.fill",
                color: .orange
            )
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.themePrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.15),
                            color.opacity(0.05),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial.opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct SettingsSectionView: View {
    let title: String
    let items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.themePrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    SettingsRowView(item: item)
                    
                    if index < items.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray.opacity(0.1),
                                Color.gray.opacity(0.05),
                                Color.clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial.opacity(0.9))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let subtitle: String?
    let hasToggle: Bool
    let toggleValue: Binding<Bool>?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        hasToggle: Bool = false,
        toggleValue: Binding<Bool>? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.hasToggle = hasToggle
        self.toggleValue = toggleValue
        self.action = action
    }
}

struct SettingsRowView: View {
    let item: SettingsItem
    
    var body: some View {
        Button(action: {
            if !item.hasToggle {
                item.action?()
            }
        }) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                // Title and Subtitle
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.subheadline)
                        .foregroundColor(Color.themePrimary)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Toggle or Arrow
                if item.hasToggle, let toggleValue = item.toggleValue {
                    Toggle("", isOn: toggleValue)
                        .labelsHidden()
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LogoutButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18))
                
                Text("Logout")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ThemeManager.shared)
}
