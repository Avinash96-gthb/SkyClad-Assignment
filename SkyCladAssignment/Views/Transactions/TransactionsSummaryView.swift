//
//  TransactionsSummaryView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI

struct TransactionsSummaryView: View {
    @EnvironmentObject var dataService: MockDataService
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTransactionType: TransactionType? = nil
    @State private var showingActionSheet = false
    
    var filteredTransactions: [Transaction] {
        if let selectedType = selectedTransactionType {
            return dataService.transactions.filter { $0.type == selectedType }
        }
        return dataService.transactions
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Large Portfolio Value Card
                PortfolioValueCard(portfolio: dataService.portfolio)
                
                // Action Buttons
                ActionButtonsView(showingActionSheet: $showingActionSheet)
                
                // Transaction Filter
                TransactionFilterView(selectedType: $selectedTransactionType)
                
                // Transactions List
                TransactionsListView(transactions: filteredTransactions)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .background(Color.themeBackground)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Select Action"),
                buttons: [
                    .default(Text("Send")) { /* Handle send */ },
                    .default(Text("Receive")) { /* Handle receive */ },
                    .default(Text("Exchange")) { /* Handle exchange */ },
                    .cancel()
                ]
            )
        }
    }
}

struct PortfolioValueCard: View {
    let portfolio: Portfolio
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Total Portfolio Value")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("₹\(formatCurrency(portfolio.totalValue))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color.themePrimary)
                
                HStack(spacing: 8) {
                    Image(systemName: portfolio.percentageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.subheadline)
                        .foregroundColor(portfolio.percentageChange >= 0 ? .green : .red)
                    
                    Text("\(portfolio.percentageChange >= 0 ? "+" : "")\(String(format: "%.2f", portfolio.percentageChange))% Today")
                        .font(.subheadline)
                        .foregroundColor(portfolio.percentageChange >= 0 ? .green : .red)
                }
            }
            
            // Portfolio Breakdown
            HStack {
                ForEach(portfolio.assets, id: \.id) { asset in
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: asset.icon)
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Text(asset.symbol)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Text("₹\(formatCurrency(asset.value))")
                            .font(.subheadline)
                            .foregroundColor(Color.themePrimary)
                        
                        Text("\(asset.percentageChange >= 0 ? "+" : "")\(String(format: "%.2f", asset.percentageChange))%")
                            .font(.caption)
                            .foregroundColor(asset.percentageChange >= 0 ? .green : .red)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
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

struct ActionButtonsView: View {
    @Binding var showingActionSheet: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ActionButton(
                icon: "arrow.down.circle.fill",
                title: "Receive",
                color: .green
            ) {
                // Handle receive action
            }
            
            ActionButton(
                icon: "arrow.up.circle.fill",
                title: "Send",
                color: .red
            ) {
                // Handle send action
            }
            
            ActionButton(
                icon: "plus.circle.fill",
                title: "Exchange",
                color: .blue
            ) {
                showingActionSheet = true
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.themePrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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

struct TransactionFilterView: View {
    @Binding var selectedType: TransactionType?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "All",
                    isSelected: selectedType == nil,
                    action: { selectedType = nil }
                )
                
                ForEach(TransactionType.allCases, id: \.self) { type in
                    FilterButton(
                        title: type.rawValue,
                        isSelected: selectedType == type,
                        action: { selectedType = type }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.white : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                        )
                )
        }
    }
}

struct TransactionsListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transactions")
                .font(.headline)
                .foregroundColor(Color.themePrimary)
                .padding(.horizontal, 20)
            
            LazyVStack(spacing: 8) {
                ForEach(transactions, id: \.id) { transaction in
                    DetailedTransactionRowView(transaction: transaction)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct DetailedTransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Transaction Icon
                Image(systemName: transaction.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(colorForTransactionType(transaction.type))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(colorForTransactionType(transaction.type).opacity(0.2))
                    )
                
                // Transaction Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(transaction.type.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.themePrimary)
                        
                        Spacer()
                        
                        Text(transaction.asset == "INR" ? 
                            "\(transaction.amount >= 0 ? "+" : "")₹\(formatCurrency(transaction.amount))" :
                            "\(transaction.amount >= 0 ? "+" : "")\(String(format: "%.6f", transaction.amount)) \(transaction.asset)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.themePrimary)
                    }
                    
                    HStack {
                        Text(formatFullDate(transaction.date))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("₹\(formatCurrency(transaction.value))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Transaction Status
            HStack {
                StatusBadge(status: transaction.status)
                
                Spacer()
                
                if let fee = transaction.fee {
                    Text("Fee: ₹\(formatCurrency(fee))")
                        .font(.caption2)
                        .foregroundColor(.gray)
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

struct StatusBadge: View {
    let status: TransactionStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(statusColor.0)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(statusColor.1)
            )
    }
    
    private var statusColor: (Color, Color) {
        switch status {
        case .completed:
            return (Color.green, Color.green.opacity(0.2))
        case .pending:
            return (Color.yellow, Color.yellow.opacity(0.2))
        case .failed:
            return (Color.red, Color.red.opacity(0.2))
        }
    }
}

func formatFullDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

#Preview {
    TransactionsSummaryView()
        .environmentObject(MockDataService.shared)
        .environmentObject(ThemeManager.shared)
}
