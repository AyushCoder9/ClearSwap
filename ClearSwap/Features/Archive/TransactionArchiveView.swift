import SwiftData
import SwiftUI

struct TransactionArchiveView: View {
    @Query(sort: \Deal.completedAt, order: .reverse) private var allDeals: [Deal]
    @Query(sort: \ReceiptRecord.createdAt, order: .reverse) private var receipts: [ReceiptRecord]

    private var completedDeals: [Deal] {
        allDeals.filter { $0.escrowStatus == .completed }
    }

    var body: some View {
        ZStack {
            TerminalBackground()
            List {
                Section("Completed Deals") {
                    if completedDeals.isEmpty {
                        Text("No completed transactions yet.")
                            .foregroundStyle(CSColor.textSecondary)
                    } else {
                        ForEach(completedDeals) { deal in
                            HStack {
                                Image(systemName: deal.imageSystemName)
                                    .foregroundStyle(CSColor.accent)
                                VStack(alignment: .leading) {
                                    Text(deal.itemTitle).font(.headline)
                                    Text(CurrencyFormatting.string(from: deal.agreedPrice))
                                        .foregroundStyle(CSColor.accent)
                                }
                                Spacer()
                                if let date = deal.completedAt {
                                    Text(date, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(CSColor.textSecondary)
                                }
                            }
                            .listRowBackground(CSColor.surface)
                        }
                    }
                }

                Section("Wallet Receipts") {
                    if receipts.isEmpty {
                        Text("Receipts appear after successful checkout.")
                            .foregroundStyle(CSColor.textSecondary)
                    } else {
                        ForEach(receipts) { receipt in
                            HStack {
                                Image(systemName: "wallet.pass.fill")
                                    .foregroundStyle(CSColor.accent)
                                VStack(alignment: .leading) {
                                    Text(receipt.itemTitle)
                                    Text(receipt.serialNumber)
                                        .font(.caption.monospaced())
                                        .foregroundStyle(CSColor.textSecondary)
                                }
                                Spacer()
                                if receipt.passAddedToWallet {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(CSColor.accent)
                                }
                            }
                            .listRowBackground(CSColor.surface)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Archive")
    }
}
