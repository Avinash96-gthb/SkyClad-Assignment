//
//  MockDataService.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import Foundation

class MockDataService: ObservableObject {
    static let shared = MockDataService()
    
    @Published var portfolio: Portfolio
    @Published var transactions: [Transaction]
    @Published var exchangePairs: [ExchangePair]
    
    private init() {
        self.portfolio = MockDataService.createMockPortfolio()
        self.transactions = MockDataService.createMockTransactions()
        self.exchangePairs = MockDataService.createMockExchangePairs()
    }
    
    // MARK: - Mock Portfolio Data
    
    static func createMockPortfolio() -> Portfolio {
        let btcHistoricalData = generateHistoricalData(baseValue: 50000, days: 365, isStableCoin: false) // Generate 1 year of data
        let ethHistoricalData = generateHistoricalData(baseValue: 3000, days: 365, isStableCoin: false) // Generate 1 year of data
        let inrHistoricalData = generateHistoricalData(baseValue: 1.0, days: 365, isStableCoin: true) // INR stable with minimal fluctuation
        
        let btcAsset = Asset(
            id: "bitcoin",
            symbol: "BTC",
            name: "Bitcoin",
            currentPrice: 52340.67,
            amount: 0.08536,
            value: 4469.84,
            percentageChange: 2.34,
            changeAmount: 102.45,
            icon: "bitcoinsign.circle.fill",
            historicalData: btcHistoricalData
        )
        
        let ethAsset = Asset(
            id: "ethereum",
            symbol: "ETH",
            name: "Ethereum",
            currentPrice: 3124.89,
            amount: 1.2456,
            value: 3891.23,
            percentageChange: -1.67,
            changeAmount: -66.12,
            icon: "e.circle.fill",
            historicalData: ethHistoricalData
        )
        
        let inrAsset = Asset(
            id: "indian-rupee",
            symbol: "INR",
            name: "Indian Rupee",
            currentPrice: 1.0,
            amount: 15420.50,
            value: 15420.50,
            percentageChange: 0.0,
            changeAmount: 0.0,
            icon: "indianrupeesign.circle.fill",
            historicalData: inrHistoricalData
        )
        
        let portfolioHistoricalData = combineHistoricalData([btcHistoricalData, ethHistoricalData, inrHistoricalData])
        
        return Portfolio(
            totalValue: 23781.57, // Updated to include INR balance
            currency: .inr,
            lastUpdated: Date(),
            assets: [btcAsset, ethAsset, inrAsset],
            historicalData: portfolioHistoricalData,
            percentageChange: 0.45,
            changeAmount: 106.82
        )
    }
    
    // MARK: - Mock Transaction Data
    
    static func createMockTransactions() -> [Transaction] {
        let calendar = Calendar.current
        
        return [
            Transaction(
                id: "tx1",
                type: .received,
                asset: "BTC",
                amount: 0.00234,
                value: 122.45,
                date: calendar.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
                status: .completed,
                fee: 0.0001,
                fromAddress: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
                toAddress: nil
            ),
            Transaction(
                id: "tx2",
                type: .sent,
                asset: "ETH",
                amount: 0.5,
                value: 1562.45,
                date: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                status: .completed,
                fee: 0.02,
                fromAddress: nil,
                toAddress: "0x742d35Cc6633C0532925a3b8D6A23bb67C5b7c9F"
            ),
            Transaction(
                id: "tx3",
                type: .bought,
                asset: "BTC",
                amount: 0.01,
                value: 523.41,
                date: calendar.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                status: .completed,
                fee: 5.23,
                fromAddress: nil,
                toAddress: nil
            ),
            Transaction(
                id: "tx4",
                type: .exchanged,
                asset: "ETH",
                amount: 0.2,
                value: 624.98,
                date: calendar.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                status: .completed,
                fee: 15.67,
                fromAddress: nil,
                toAddress: nil
            ),
            Transaction(
                id: "tx5",
                type: .received,
                asset: "BTC",
                amount: 0.005,
                value: 261.70,
                date: calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                status: .completed,
                fee: 0.0001,
                fromAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                toAddress: nil
            ),
            Transaction(
                id: "tx6",
                type: .sent,
                asset: "ETH",
                amount: 1.0,
                value: 3124.89,
                date: calendar.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                status: .pending,
                fee: 0.05,
                fromAddress: nil,
                toAddress: "0x8ba1f109551bD432803012645Hac136c22C"
            ),
            Transaction(
                id: "tx7",
                type: .exchanged,
                asset: "INR",
                amount: 5000.0,
                value: 5000.0,
                date: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                status: .completed,
                fee: 0.0,
                fromAddress: nil,
                toAddress: nil
            ),
            Transaction(
                id: "tx8",
                type: .received,
                asset: "INR",
                amount: 10000.0,
                value: 10000.0,
                date: calendar.date(byAdding: .day, value: -12, to: Date()) ?? Date(),
                status: .completed,
                fee: 0.0,
                fromAddress: nil,
                toAddress: nil
            )
        ]
    }
    
    // MARK: - Mock Exchange Data
    
    static func createMockExchangePairs() -> [ExchangePair] {
        return [
            ExchangePair(
                fromAsset: "ETH",
                toAsset: "INR",
                rate: 258742.35,
                spread: 0.5,
                gasFee: 1250.00,
                minimumAmount: 0.001,
                maximumAmount: 100.0
            ),
            ExchangePair(
                fromAsset: "BTC",
                toAsset: "INR",
                rate: 4334523.78,
                spread: 0.3,
                gasFee: 2100.00,
                minimumAmount: 0.0001,
                maximumAmount: 10.0
            ),
            ExchangePair(
                fromAsset: "INR",
                toAsset: "ETH",
                rate: 0.00000386,
                spread: 0.5,
                gasFee: 1250.00,
                minimumAmount: 1000.0,
                maximumAmount: 10000000.0
            ),
            ExchangePair(
                fromAsset: "INR",
                toAsset: "BTC",
                rate: 0.00000023,
                spread: 0.3,
                gasFee: 2100.00,
                minimumAmount: 1000.0,
                maximumAmount: 50000000.0
            )
        ]
    }
    
    // MARK: - Helper Functions
    
    static func generateHistoricalData(baseValue: Double, days: Int, isStableCoin: Bool = false) -> [PortfolioDataPoint] {
        var data: [PortfolioDataPoint] = []
        let calendar = Calendar.current
        let totalHours = days * 24
        
        // Create more realistic price movement with trends
        var currentValue = baseValue
        let trendDirection = Double.random(in: -1...1) // Random trend direction
        let trendStrength = isStableCoin ? 0.001 : Double.random(in: 0.1...0.3) // Much lower trend for stable coins
        
        for i in 0..<totalHours {
            let date = calendar.date(byAdding: .hour, value: -i, to: Date()) ?? Date()
            
            // Add progressive trend over time
            let timeProgress = Double(i) / Double(totalHours)
            let trendComponent = trendDirection * trendStrength * timeProgress
            
            // Add volatility based on time period and coin type
            let volatility = isStableCoin ? 0.001 : (days <= 1 ? 0.08 : (days <= 7 ? 0.05 : 0.03))
            let randomVariation = Double.random(in: -volatility...volatility)
            
            // Add market cycles (daily and weekly patterns) - much smaller for stable coins
            let hourOfDay = calendar.component(.hour, from: date)
            let dailyCycle = sin(Double(hourOfDay) * 2 * .pi / 24) * (isStableCoin ? 0.0005 : 0.02)
            let weeklyCycle = sin(Double(i) * 2 * .pi / (24 * 7)) * (isStableCoin ? 0.0003 : 0.015)
            
            // Apply momentum (previous movement influences next) - minimal for stable coins
            let momentum = i > 0 ? (currentValue - baseValue) / baseValue * (isStableCoin ? 0.01 : 0.1) : 0
            
            let totalChange = trendComponent + randomVariation + dailyCycle + weeklyCycle + momentum
            currentValue = baseValue * (1 + totalChange)
            
            // Keep values reasonable - tighter range for stable coins
            if isStableCoin {
                currentValue = max(min(currentValue, baseValue * 1.002), baseValue * 0.998)
            } else {
                currentValue = max(min(currentValue, baseValue * 3.0), baseValue * 0.1)
            }
            
            data.append(PortfolioDataPoint(timestamp: date, value: currentValue))
        }
        
        return data.reversed()
    }
    
    static func combineHistoricalData(_ datasets: [[PortfolioDataPoint]]) -> [PortfolioDataPoint] {
        guard !datasets.isEmpty else { return [] }
        
        let minCount = datasets.map { $0.count }.min() ?? 0
        var combinedData: [PortfolioDataPoint] = []
        
        for i in 0..<minCount {
            let timestamp = datasets[0][i].timestamp
            let totalValue = datasets.reduce(0) { sum, dataset in
                sum + dataset[i].value
            }
            combinedData.append(PortfolioDataPoint(timestamp: timestamp, value: totalValue))
        }
        
        return combinedData
    }
    
    // MARK: - Data Updates
    
    func updatePortfolioValue(for currency: CurrencyType) {
        var updatedPortfolio = portfolio
        updatedPortfolio.currency = currency
        // In a real app, you'd convert the values here
        self.portfolio = updatedPortfolio
    }
    
    func updateAssetBalance(symbol: String, newAmount: Double) {
        var updatedPortfolio = portfolio
        if let index = updatedPortfolio.assets.firstIndex(where: { $0.symbol == symbol }) {
            var updatedAsset = updatedPortfolio.assets[index]
            updatedAsset.amount = newAmount
            updatedAsset.value = newAmount * updatedAsset.currentPrice
            updatedPortfolio.assets[index] = updatedAsset
            
            // Recalculate total portfolio value
            updatedPortfolio.totalValue = updatedPortfolio.assets.reduce(0) { $0 + $1.value }
            
            self.portfolio = updatedPortfolio
        }
    }
    
    func getExchangeRate(from: String, to: String) -> ExchangePair? {
        return exchangePairs.first { $0.fromAsset == from && $0.toAsset == to }
    }
    
    func performExchange(fromSymbol: String, toSymbol: String, fromAmount: Double, toAmount: Double) {
        // Update source asset balance
        if let fromAssetIndex = portfolio.assets.firstIndex(where: { $0.symbol == fromSymbol }) {
            let currentFromAmount = portfolio.assets[fromAssetIndex].amount
            updateAssetBalance(symbol: fromSymbol, newAmount: currentFromAmount - fromAmount)
        }
        
        // Update destination asset balance
        if let toAssetIndex = portfolio.assets.firstIndex(where: { $0.symbol == toSymbol }) {
            let currentToAmount = portfolio.assets[toAssetIndex].amount
            updateAssetBalance(symbol: toSymbol, newAmount: currentToAmount + toAmount)
        }
        
        // Add transaction record
        let newTransaction = Transaction(
            id: "tx_\(UUID().uuidString.prefix(8))",
            type: .exchanged,
            asset: fromSymbol,
            amount: fromAmount,
            value: fromAmount * (portfolio.assets.first(where: { $0.symbol == fromSymbol })?.currentPrice ?? 0),
            date: Date(),
            status: .completed,
            fee: 0.1, // Small exchange fee
            fromAddress: nil,
            toAddress: nil
        )
        
        transactions.insert(newTransaction, at: 0)
    }
}
