//
//  AssetsView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI
import Charts

struct AssetsView: View {
    @EnvironmentObject var dataService: MockDataService
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedAsset: Asset?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                AssetsHeaderView(totalValue: dataService.portfolio.totalValue)
                
                // Assets List
                AssetsListView(
                    assets: dataService.portfolio.assets,
                    selectedAsset: $selectedAsset
                )
                
                // Asset Detail Modal
                if let asset = selectedAsset {
                    AssetDetailView(asset: asset)
                        .transition(.move(edge: .bottom))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .background(Color.themeBackground)
        .animation(.easeInOut(duration: 0.3), value: selectedAsset)
    }
}

struct AssetsHeaderView: View {
    let totalValue: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Assets")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.themePrimary)
            
            Text("Total Value: ₹\(formatCurrency(totalValue))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AssetsListView: View {
    let assets: [Asset]
    @Binding var selectedAsset: Asset?
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(assets, id: \.id) { asset in
                DetailedAssetCard(asset: asset) {
                    selectedAsset = asset
                }
            }
        }
    }
}

struct DetailedAssetCard: View {
    let asset: Asset
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Asset Icon
                    AssetIcon(symbol: asset.symbol)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(assetColor.opacity(0.2))
                        )
                    
                    // Asset Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(asset.name)
                                .font(.headline)
                                .foregroundColor(Color.themePrimary)
                            
                            Spacer()
                            
                            Text("₹\(formatCurrency(asset.value))")
                                .font(.headline)
                                .foregroundColor(Color.themePrimary)
                        }
                        
                        HStack {
                            Text(asset.symbol == "INR" ? 
                                "₹\(formatCurrency(asset.amount))" : 
                                "\(String(format: "%.6f", asset.amount)) \(asset.symbol)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: asset.percentageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.caption)
                                    .foregroundColor(asset.percentageChange >= 0 ? .green : .red)
                                
                                Text("\(asset.percentageChange >= 0 ? "+" : "")\(String(format: "%.2f", asset.percentageChange))%")
                                    .font(.subheadline)
                                    .foregroundColor(asset.percentageChange >= 0 ? .green : .red)
                            }
                        }
                    }
                }
                
                // Mini Chart
                Chart(asset.historicalData.suffix(24), id: \.timestamp) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.timestamp),
                        y: .value("Price", dataPoint.value)
                    )
                    .foregroundStyle(asset.percentageChange >= 0 ? Color.green : Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
                .frame(height: 60)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartBackground { _ in
                    Rectangle()
                        .fill(.clear)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                asset.percentageChange >= 0 ? 
                                    Color.green.opacity(0.2) : Color.red.opacity(0.2),
                                asset.percentageChange >= 0 ? 
                                    Color.green.opacity(0.08) : Color.red.opacity(0.08),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var assetColor: Color {
        switch asset.symbol {
        case "BTC": return .orange
        case "ETH": return .blue
        default: return .gray
        }
    }
}

struct AssetDetailView: View {
    let asset: Asset
    @State private var selectedTimePeriod: TimePeriod = .oneDay
    
    var filteredData: [PortfolioDataPoint] {
        let hours = selectedTimePeriod.hours
        return Array(asset.historicalData.suffix(hours))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themePrimary)
                    
                    Text("₹\(formatCurrency(asset.currentPrice))")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                AssetIcon(symbol: asset.symbol)
                    .frame(width: 48, height: 48)
            }
            
            // Price Change
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: asset.percentageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.subheadline)
                        .foregroundColor(asset.percentageChange >= 0 ? .green : .red)
                    
                    Text("\(asset.percentageChange >= 0 ? "+" : "")\(String(format: "%.2f", asset.percentageChange))%")
                        .font(.headline)
                        .foregroundColor(asset.percentageChange >= 0 ? .green : .red)
                    
                    Text("(\(asset.changeAmount >= 0 ? "+" : "")₹\(formatCurrency(asset.changeAmount)))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Time Period Selector
            TimePeriodSelector(selectedPeriod: $selectedTimePeriod)
            
            // Chart
            Chart(filteredData, id: \.timestamp) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Price", dataPoint.value)
                )
                .foregroundStyle(asset.percentageChange >= 0 ? Color.green : Color.red)
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                AreaMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Price", dataPoint.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            (asset.percentageChange >= 0 ? Color.green : Color.red).opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(height: 200)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            // Holdings Info
            VStack(spacing: 12) {
                HoldingInfoRow(
                    title: "Holdings",
                    value: asset.symbol == "INR" ? 
                        "₹\(formatCurrency(asset.amount))" : 
                        "\(String(format: "%.6f", asset.amount)) \(asset.symbol)"
                )
                
                HoldingInfoRow(
                    title: "Total Value",
                    value: "₹\(formatCurrency(asset.value))"
                )
                
                HoldingInfoRow(
                    title: "Average Cost",
                    value: "₹\(formatCurrency(asset.currentPrice * 0.95))" // Mock average cost
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray.opacity(0.15),
                                Color.gray.opacity(0.05),
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
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            
            // Action Buttons
            HStack(spacing: 12) {
                AssetActionButton(title: "Buy", icon: "plus.circle.fill", color: .green) {
                    // Handle buy action
                }
                
                AssetActionButton(title: "Sell", icon: "minus.circle.fill", color: .red) {
                    // Handle sell action
                }
                
                AssetActionButton(title: "Send", icon: "arrow.up.circle.fill", color: .blue) {
                    // Handle send action
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct HoldingInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color.themePrimary)
        }
    }
}

struct AssetActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.themePrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    AssetsView()
        .environmentObject(MockDataService.shared)
        .environmentObject(ThemeManager.shared)
}
