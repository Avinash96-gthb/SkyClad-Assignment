//
//  ExchangeView.swift
//  SkyCladAssignment
//
//  Created by A Avinash Chidambaram on 17/08/25.
//

import SwiftUI

struct ExchangeView: View {
    @EnvironmentObject var dataService: MockDataService
    @EnvironmentObject var themeManager: ThemeManager
    @State private var fromAsset = "ETH"
    @State private var toAsset = "INR"
    @State private var fromAmount = ""
    @State private var toAmount = ""
    @State private var isEditing = false
    @State private var showingSuccessAlert = false
    @State private var isExchanging = false
    
    private var exchangePair: ExchangePair? {
        dataService.getExchangeRate(from: fromAsset, to: toAsset)
    }
    
    private var calculatedToAmount: Double {
        guard let amount = Double(fromAmount),
              let pair = exchangePair else { return 0 }
        return amount * pair.rate
    }
    
    private var calculatedFromAmount: Double {
        guard let amount = Double(toAmount),
              let pair = exchangePair else { return 0 }
        return amount / pair.rate
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                ExchangeHeaderView()
                
                // Exchange Card
                ExchangeCardView(
                    fromAsset: $fromAsset,
                    toAsset: $toAsset,
                    fromAmount: $fromAmount,
                    toAmount: $toAmount,
                    isEditing: $isEditing,
                    calculatedToAmount: calculatedToAmount,
                    calculatedFromAmount: calculatedFromAmount
                )
                
                // Exchange Summary
                if let pair = exchangePair, !fromAmount.isEmpty || !toAmount.isEmpty {
                    ExchangeSummaryView(
                        pair: pair,
                        fromAsset: fromAsset,
                        toAsset: toAsset,
                        fromAmount: Double(fromAmount) ?? 0
                    )
                }
                
                // Exchange Button
                ExchangeActionButton(
                    isEnabled: !fromAmount.isEmpty && Double(fromAmount) ?? 0 > 0 && !isExchanging,
                    isExchanging: isExchanging,
                    fromAsset: fromAsset,
                    toAsset: toAsset,
                    amount: Double(fromAmount) ?? 0
                ) {
                    performExchange()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .background(Color.themeBackground)
        .alert("Exchange Successful!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                resetExchangeForm()
            }
        } message: {
            Text("Your exchange has been completed successfully.")
        }
        .onChange(of: fromAmount) { _, newValue in
            if isEditing && !newValue.isEmpty {
                toAmount = String(format: "%.6f", calculatedToAmount)
            }
        }
        .onChange(of: toAmount) { _, newValue in
            if isEditing && !newValue.isEmpty {
                fromAmount = String(format: "%.6f", calculatedFromAmount)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func performExchange() {
        isExchanging = true
        
        // Simulate exchange processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let fromAmountValue = Double(fromAmount) ?? 0
            let toAmountValue = calculatedToAmount
            
            // Actually perform the exchange through the data service
            dataService.performExchange(
                fromSymbol: fromAsset,
                toSymbol: toAsset,
                fromAmount: fromAmountValue,
                toAmount: toAmountValue
            )
            
            isExchanging = false
            showingSuccessAlert = true
        }
    }
    
    private func resetExchangeForm() {
        fromAmount = ""
        toAmount = ""
        isEditing = false
        fromAsset = "ETH"
        toAsset = "INR"
    }
}

struct ExchangeHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exchange")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.themePrimary)
            
            Text("Swap your crypto assets instantly")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ExchangeCardView: View {
    @Binding var fromAsset: String
    @Binding var toAsset: String
    @Binding var fromAmount: String
    @Binding var toAmount: String
    @Binding var isEditing: Bool
    let calculatedToAmount: Double
    let calculatedFromAmount: Double
    
    let assets = ["ETH", "BTC", "INR"]
    
    var body: some View {
        VStack(spacing: 16) {
            // From Section
            VStack(spacing: 12) {
                HStack {
                    Text("From")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Balance: 1.2456 ETH")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 12) {
                    // Asset Selector
                    Menu {
                        ForEach(assets, id: \.self) { asset in
                            Button(asset) {
                                fromAsset = asset
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            AssetIcon(symbol: fromAsset)
                            
                            Text(fromAsset)
                                .font(.headline)
                                .foregroundColor(Color.themePrimary)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    
                    Spacer()
                    
                    // Amount Input
                    TextField("0.0", text: $fromAmount)
                        .font(.headline)
                        .foregroundColor(Color.themePrimary)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onTapGesture {
                            isEditing = true
                        }
                }
            }
            
            // Swap Button
            Button(action: {
                let temp = fromAsset
                fromAsset = toAsset
                toAsset = temp
                
                let tempAmount = fromAmount
                fromAmount = toAmount
                toAmount = tempAmount
            }) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            
            // To Section
            VStack(spacing: 12) {
                HStack {
                    Text("To")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if toAsset != "INR" {
                        Text("Balance: 0.0856 BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack(spacing: 12) {
                    // Asset Selector
                    Menu {
                        ForEach(assets, id: \.self) { asset in
                            Button(asset) {
                                toAsset = asset
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            AssetIcon(symbol: toAsset)
                            
                            Text(toAsset)
                                .font(.headline)
                                .foregroundColor(Color.themePrimary)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    
                    Spacer()
                    
                    // Amount Display/Input
                    if isEditing && !fromAmount.isEmpty {
                        Text(String(format: "%.6f", calculatedToAmount))
                            .font(.headline)
                            .foregroundColor(Color.themePrimary)
                    } else {
                        TextField("0.0", text: $toAmount)
                            .font(.headline)
                            .foregroundColor(Color.themePrimary)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
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

struct AssetIcon: View {
    let symbol: String
    
    var body: some View {
        Group {
            switch symbol {
            case "BTC":
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.orange)
            case "ETH":
                Image(systemName: "e.circle.fill")
                    .foregroundColor(.blue)
            case "INR":
                Image(systemName: "indianrupeesign.circle.fill")
                    .foregroundColor(.green)
            default:
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .font(.system(size: 24))
    }
}

struct ExchangeSummaryView: View {
    let pair: ExchangePair
    let fromAsset: String
    let toAsset: String
    let fromAmount: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Exchange Summary")
                .font(.headline)
                .foregroundColor(Color.themePrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                SummaryRow(
                    title: "Exchange Rate",
                    value: "1 \(fromAsset) = \(formatCurrency(pair.rate)) \(toAsset)"
                )
                
                SummaryRow(
                    title: "Spread",
                    value: "\(String(format: "%.2f", pair.spread))%"
                )
                
                SummaryRow(
                    title: "Gas Fee",
                    value: "₹\(formatCurrency(pair.gasFee))"
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                SummaryRow(
                    title: "You will receive",
                    value: "\(String(format: "%.6f", fromAmount * pair.rate - pair.gasFee)) \(toAsset)",
                    isHighlighted: true
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.25),
                            Color.yellow.opacity(0.15),
                            Color.clear
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct SummaryRow: View {
    let title: String
    let value: String
    let isHighlighted: Bool
    
    init(title: String, value: String, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(isHighlighted ? .subheadline : .subheadline)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundColor(isHighlighted ? .white : .gray)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? .subheadline : .subheadline)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundColor(isHighlighted ? .blue : .white)
        }
    }
}

struct ExchangeActionButton: View {
    let isEnabled: Bool
    let isExchanging: Bool
    let fromAsset: String
    let toAsset: String
    let amount: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isExchanging {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    
                    Text("Processing...")
                        .font(.headline)
                        .fontWeight(.semibold)
                } else {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Exchange Now")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(isEnabled ? .black : .gray)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isEnabled ? Color.white : Color.gray.opacity(0.3))
            )
        }
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isExchanging)
    }
}

#Preview {
    ExchangeView()
        .environmentObject(MockDataService.shared)
        .environmentObject(ThemeManager.shared)
}
