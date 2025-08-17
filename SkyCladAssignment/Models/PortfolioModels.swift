//
//  PortfolioModels.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import Foundation

// MARK: - Portfolio Data Models

struct Portfolio {
    var totalValue: Double
    var currency: CurrencyType
    let lastUpdated: Date
    var assets: [Asset]
    let historicalData: [PortfolioDataPoint]
    let percentageChange: Double
    let changeAmount: Double
}

struct PortfolioDataPoint: Equatable {
    let timestamp: Date
    let value: Double
}

struct Asset: Equatable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    var amount: Double
    var value: Double
    let percentageChange: Double
    let changeAmount: Double
    let icon: String
    let historicalData: [PortfolioDataPoint]
}

// MARK: - Transaction Models

struct Transaction {
    let id: String
    let type: TransactionType
    let asset: String
    let amount: Double
    let value: Double
    let date: Date
    let status: TransactionStatus
    let fee: Double?
    let fromAddress: String?
    let toAddress: String?
}

enum TransactionType: String, CaseIterable {
    case received = "Received"
    case sent = "Sent"
    case bought = "Bought"
    case sold = "Sold"
    case exchanged = "Exchanged"
    
    var icon: String {
        switch self {
        case .received: return "arrow.down.circle.fill"
        case .sent: return "arrow.up.circle.fill"
        case .bought: return "plus.circle.fill"
        case .sold: return "minus.circle.fill"
        case .exchanged: return "arrow.2.squarepath"
        }
    }
    
    var color: String {
        switch self {
        case .received, .bought: return "green"
        case .sent, .sold: return "red"
        case .exchanged: return "blue"
        }
    }
}

enum TransactionStatus: String, CaseIterable {
    case completed = "Completed"
    case pending = "Pending"
    case failed = "Failed"
}

// MARK: - Exchange Models

struct ExchangePair {
    let fromAsset: String
    let toAsset: String
    let rate: Double
    let spread: Double
    let gasFee: Double
    let minimumAmount: Double
    let maximumAmount: Double
}

// MARK: - Currency & Time Period

enum CurrencyType: String, CaseIterable {
    case inr = "INR"
    case usd = "USD"
    case crypto = "CRYPTO"
    
    var symbol: String {
        switch self {
        case .inr: return "₹"
        case .usd: return "$"
        case .crypto: return "₿"
        }
    }
}

enum TimePeriod: String, CaseIterable {
    case oneHour = "1H"
    case eightHours = "8H"
    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case oneYear = "1Y"
    
    var hours: Int {
        switch self {
        case .oneHour: return 1
        case .eightHours: return 8
        case .oneDay: return 24
        case .oneWeek: return 168
        case .oneMonth: return 720
        case .oneYear: return 8760
        }
    }
}

// MARK: - Tab Navigation

enum TabItem: String, CaseIterable {
    case portfolio = "Portfolio"
    case transactions = "Transactions"
    case exchange = "Exchange"
    case assets = "Assets"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .portfolio: return "chart.line.uptrend.xyaxis"
        case .transactions: return "list.bullet"
        case .exchange: return "arrow.2.squarepath"
        case .assets: return "bitcoinsign.circle"
        case .profile: return "person.circle"
        }
    }
}
