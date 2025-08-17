//
//  MainTabView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .portfolio
    @StateObject private var dataService = MockDataService.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            TabView(selection: $selectedTab) {
                PortfolioDashboardView()
                    .environmentObject(dataService)
                    .environmentObject(themeManager)
                    .tag(TabItem.portfolio)
                
                TransactionsSummaryView()
                    .environmentObject(dataService)
                    .environmentObject(themeManager)
                    .tag(TabItem.transactions)
                
                ExchangeView()
                    .environmentObject(dataService)
                    .environmentObject(themeManager)
                    .tag(TabItem.exchange)
                
                AssetsView()
                    .environmentObject(dataService)
                    .environmentObject(themeManager)
                    .tag(TabItem.assets)
                
                ProfileView()
                    .environmentObject(themeManager)
                    .tag(TabItem.profile)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(tab.rawValue)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .blue : .gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    MainTabView()
}
