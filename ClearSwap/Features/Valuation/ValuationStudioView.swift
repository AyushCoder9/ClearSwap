import Charts
import SwiftData
import SwiftUI

struct ValuationStudioView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var valuationService = ValuationService.shared
    @State private var itemTitle = "iPhone 15 Pro 256GB"
    @State private var category = "Electronics"
    @State private var condition: ItemCondition = .mint
    @State private var basePrice: Decimal = 95_000
    @State private var selectedOffset: Int = 0
    @State private var showDealCreated = false
    @State private var chartAnimates = false

    private var bellPoints: [MarketDataPoint] {
        valuationService.bellCurvePoints(
            basePrice: (basePrice as NSDecimalNumber).doubleValue,
            condition: condition
        )
    }

    private var recommended: Decimal {
        valuationService.priceForCondition(basePrice: basePrice, condition: condition)
    }

    private var range: (low: Decimal, high: Decimal) {
        valuationService.recommendedRange(basePrice: basePrice, condition: condition)
    }

    var body: some View {
        ZStack {
            TerminalBackground()
            
            // Dynamic Mesh Overlay
            RadialGradient(
                colors: [CSColor.accent.opacity(0.15), .clear],
                center: .topTrailing,
                startRadius: 50,
                endRadius: 600
            )
            .ignoresSafeArea()
            .opacity(chartAnimates ? 1.0 : 0.4)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: chartAnimates)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CSTypography.caption("MARKET VALUATION STUDIO")
                    CSTypography.largeTitle("Price Intelligence")

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Item name", text: $itemTitle)
                                .textFieldStyle(.roundedBorder)
                            TextField("Category", text: $category)
                                .textFieldStyle(.roundedBorder)

                            Picker("Condition", selection: $condition) {
                                ForEach(ItemCondition.allCases) { c in
                                    Text(c.displayName).tag(c)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            CSTypography.caption("RECOMMENDED RANGE")
                            Text("\(CurrencyFormatting.string(from: range.low)) – \(CurrencyFormatting.string(from: range.high))")
                                .font(.title2.bold())
                                .foregroundStyle(CSColor.accent)
                            CSTypography.body("Fair market value for \(condition.displayName) condition")
                        }
                    }

                    GlassCard {
                        Chart(bellPoints) { point in
                            AreaMark(
                                x: .value("Offset", point.dayOffset),
                                y: .value("Price", point.price)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [CSColor.accent.opacity(0.5), CSColor.accent.opacity(0.05)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            LineMark(
                                x: .value("Offset", point.dayOffset),
                                y: .value("Price", point.price)
                            )
                            .foregroundStyle(CSColor.accent)
                            .lineStyle(StrokeStyle(lineWidth: 2))

                            if point.dayOffset == selectedOffset {
                                PointMark(
                                    x: .value("Offset", point.dayOffset),
                                    y: .value("Price", point.price)
                                )
                                .foregroundStyle(.white)
                                .symbolSize(80)
                            }
                        }
                        .chartXAxisLabel("Market Position")
                        .chartYAxisLabel("Price (₹)")
                        .frame(height: 220)
                        .scaleEffect(chartAnimates ? 1 : 0.95, anchor: .bottom)
                        .opacity(chartAnimates ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: chartAnimates)
                        .chartOverlay { proxy in
                            GeometryReader { geo in
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                let x = value.location.x - geo[proxy.plotFrame!].origin.x
                                                if let offset: Int = proxy.value(atX: x) {
                                                    let clamped = max(-15, min(15, offset))
                                                    if clamped != selectedOffset {
                                                        selectedOffset = clamped
                                                        UISelectionFeedbackGenerator().selectionChanged()
                                                    }
                                                }
                                            }
                                    )
                            }
                        }

                        if let point = bellPoints.first(where: { $0.dayOffset == selectedOffset }) {
                            CSTypography.mono("Selected: ₹\(Int(point.price)) · \(condition.displayName)")
                        }
                    }

                    // Historical Depreciation Line Chart
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                CSTypography.caption("30-DAY PRICE HISTORY")
                                Spacer()
                                Text("↓ \(Int((1 - condition.priceMultiplier) * 100))% from new")
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundStyle(CSColor.warning)
                            }
                            let historicalPrices = valuationService.generateHistoricalPrices(
                                basePrice: (basePrice as NSDecimalNumber).doubleValue
                            )
                            let pricePoints = historicalPrices.enumerated().map { i, p in
                                HistoricalPricePoint(day: i, price: p)
                            }
                            Chart(pricePoints) { point in
                                AreaMark(
                                    x: .value("Day", point.day),
                                    y: .value("Price", point.price)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [CSColor.warning.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                LineMark(
                                    x: .value("Day", point.day),
                                    y: .value("Price", point.price)
                                )
                                .foregroundStyle(CSColor.warning)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: 7)) { value in
                                    AxisValueLabel {
                                        if let d = value.as(Int.self) {
                                            Text("\(d)d ago")
                                                .font(.caption2)
                                                .foregroundStyle(CSColor.textSecondary)
                                        }
                                    }
                                }
                            }
                            .chartYAxis { AxisMarks { _ in AxisGridLine() } }
                            .frame(height: 140)
                            .opacity(chartAnimates ? 1 : 0.4)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: chartAnimates)
                        }
                    }

                    CSPrimaryButton("Lock Price & Create Deal", icon: "link") {
                        createDeal()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Pricing")
        .onAppear {
            basePrice = valuationService.lookupMarketPrice(itemTitle: itemTitle, category: category)
            withAnimation { chartAnimates = true }
        }
        .onChange(of: itemTitle) { _, _ in
            basePrice = valuationService.lookupMarketPrice(itemTitle: itemTitle, category: category)
        }
        .alert("Deal Created", isPresented: $showDealCreated) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Deal locked at \(CurrencyFormatting.string(from: recommended)). Check the Deals tab.")
        }
    }

    private func createDeal() {
        let deal = Deal(
            itemTitle: itemTitle,
            category: category,
            agreedPrice: recommended,
            condition: condition,
            sellerName: "Arjun K.",
            buyerName: "Demo Buyer",
            meetupLocation: MeetupLocation(name: "Select City Walk, Saket", latitude: 28.5244, longitude: 77.2066),
            meetupTime: Date().addingTimeInterval(7200),
            escrowStatus: .priceLocked,
            imageSystemName: iconForCategory(category)
        )
        modelContext.insert(deal)
        try? modelContext.save()
        HapticsService.shared.playSuccess()
        showDealCreated = true
    }

    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "electronics": "iphone.gen3"
        case "audio": "headphones"
        default: "shippingbox.fill"
        }
    }
}

struct NewDealView: View {
    var body: some View {
        ValuationStudioView()
            .navigationTitle("New Deal")
    }
}

// MARK: - Formatting update
