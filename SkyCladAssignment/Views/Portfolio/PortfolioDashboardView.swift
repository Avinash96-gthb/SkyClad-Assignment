//
//  PortfolioDashboardView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI
import Charts

struct PortfolioDashboardView: View {
    @EnvironmentObject var dataService: MockDataService
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTimePeriod: TimePeriod = .oneDay
    @State private var selectedCurrency: CurrencyType = .inr
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Portfolio Header
                PortfolioHeaderView(
                    portfolio: dataService.portfolio,
                    selectedCurrency: $selectedCurrency
                )
                
                // Time Period Selector
                TimePeriodSelector(selectedPeriod: $selectedTimePeriod)
                
                // Portfolio Chart
                PortfolioChartView(
                    data: dataService.portfolio.historicalData,
                    timePeriod: selectedTimePeriod
                )
                
                // Assets Section
                AssetsSection(assets: dataService.portfolio.assets)
                
                // Recent Transactions
                RecentTransactionsSection(transactions: Array(dataService.transactions.prefix(5)))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .background(Color.themeBackground)
    }
}

struct PortfolioHeaderView: View {
    let portfolio: Portfolio
    @Binding var selectedCurrency: CurrencyType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Portfolio Value")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Currency Toggle
                Menu {
                    ForEach(CurrencyType.allCases, id: \.self) { currency in
                        Button(currency.rawValue) {
                            selectedCurrency = currency
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedCurrency.rawValue)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(selectedCurrency.symbol)\(formatCurrency(portfolio.totalValue))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themePrimary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: portfolio.percentageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption)
                            .foregroundColor(portfolio.percentageChange >= 0 ? .green : .red)
                        
                        Text("\(portfolio.percentageChange >= 0 ? "+" : "")\(String(format: "%.2f", portfolio.percentageChange))%")
                            .font(.subheadline)
                            .foregroundColor(portfolio.percentageChange >= 0 ? .green : .red)
                        
                        Text("(\(portfolio.changeAmount >= 0 ? "+" : "")\(selectedCurrency.symbol)\(formatCurrency(portfolio.changeAmount)))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct TimePeriodSelector: View {
    @Binding var selectedPeriod: TimePeriod
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                    }) {
                        Text(period.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedPeriod == period ? .black : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedPeriod == period ? Color.white : Color.clear)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PortfolioChartView: View {
    let data: [PortfolioDataPoint]
    let timePeriod: TimePeriod
    
    var filteredData: [PortfolioDataPoint] {
        let now = Date()
        let calendar = Calendar.current
        
        let startDate: Date
        switch timePeriod {
        case .oneHour:
            startDate = calendar.date(byAdding: .hour, value: -1, to: now) ?? now
        case .eightHours:
            startDate = calendar.date(byAdding: .hour, value: -8, to: now) ?? now
        case .oneDay:
            startDate = calendar.date(byAdding: .day, value: -1, to: now) ?? now
        case .oneWeek:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .oneMonth:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .oneYear:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        let filtered = data.filter { $0.timestamp >= startDate }
        
        // Ensure we always have at least some data points for short periods
        if filtered.isEmpty || (filtered.count < 5 && [.oneHour, .eightHours].contains(timePeriod)) {
            // For short periods with insufficient data, use the last available data points
            let fallbackCount = timePeriod == .oneHour ? 10 : 24
            return Array(data.suffix(fallbackCount))
        }
        
        // For longer periods, sample the data to improve performance and readability
        switch timePeriod {
        case .oneWeek:
            // Sample every 2nd point for week view
            return filtered.enumerated().compactMap { index, point in
                index % 2 == 0 ? point : nil
            }
        case .oneMonth:
            // Sample every 8th point for month view
            return filtered.enumerated().compactMap { index, point in
                index % 8 == 0 ? point : nil
            }
        case .oneYear:
            // Sample every 24th point for year view (daily)
            return filtered.enumerated().compactMap { index, point in
                index % 24 == 0 ? point : nil
            }
        default:
            return filtered
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Portfolio Trend")
                .font(.headline)
                .foregroundColor(Color.themePrimary)
                .padding(.horizontal, 20)
            
            if filteredData.isEmpty {
                VStack {
                    Text("No data available")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("for \(timePeriod.rawValue)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            } else {
                Chart(filteredData, id: \.timestamp) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.timestamp),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    
                    AreaMark(
                        x: .value("Time", dataPoint.timestamp),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct AssetsSection: View {
    let assets: [Asset]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Assets")
                .font(.headline)
                .foregroundColor(Color.themePrimary)
                .padding(.horizontal, 20)
            
            LazyVStack(spacing: 12) {
                ForEach(assets, id: \.id) { asset in
                    AssetCard(asset: asset)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AssetCard: View {
    let asset: Asset
    
    var body: some View {
        HStack(spacing: 16) {
            // Asset Icon
            Image(systemName: asset.icon)
                .font(.system(size: 24))
                .foregroundColor(.orange)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.orange.opacity(0.2)))
            
            // Asset Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(asset.symbol)
                        .font(.headline)
                        .foregroundColor(Color.themePrimary)
                    
                    Spacer()
                    
                    Text("₹\(formatCurrency(asset.value))")
                        .font(.headline)
                        .foregroundColor(Color.themePrimary)
                }
                
                HStack {
                    Text("\(String(format: "%.5f", asset.amount)) \(asset.symbol)")
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
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct RecentTransactionsSection: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                    .foregroundColor(Color.themePrimary)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to transactions view
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 8) {
                ForEach(transactions, id: \.id) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Transaction Icon
            Image(systemName: transaction.type.icon)
                .font(.system(size: 20))
                .foregroundColor(colorForTransactionType(transaction.type))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(colorForTransactionType(transaction.type).opacity(0.2))
                )
            
            // Transaction Info
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(Color.themePrimary)
                
                Text(formatDate(transaction.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Amount and Asset
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(String(format: "%.5f", transaction.amount)) \(transaction.asset)")
                    .font(.subheadline)
                    .foregroundColor(Color.themePrimary)
                
                Text("₹\(formatCurrency(transaction.value))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Helper Functions

func formatCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: value)) ?? "0.00"
}

func formatDate(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
}

func colorForTransactionType(_ type: TransactionType) -> Color {
    switch type {
    case .received, .bought:
        return .green
    case .sent, .sold:
        return .red
    case .exchanged:
        return .blue
    }
}

#Preview {
    PortfolioDashboardView()
        .environmentObject(MockDataService.shared)
        .environmentObject(ThemeManager.shared)
}
