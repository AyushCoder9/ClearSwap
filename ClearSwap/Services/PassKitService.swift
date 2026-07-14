import PassKit
import SwiftUI
import UIKit

struct WalletPassMetadata: Sendable {
    let dealID: UUID
    let itemTitle: String
    let serialNumber: String
    let amountPaid: Decimal
    let sellerName: String
    let buyerName: String
    let purchaseDate: Date
    let warrantyExpires: Date
}

@MainActor
final class PassKitService: ObservableObject {
    static let shared = PassKitService()

    @Published var lastPass: PKPass?
    @Published var canAddToWallet = false

    func buildPass(from metadata: WalletPassMetadata) -> PKPass? {
        guard let passData = buildPassPackage(metadata: metadata) else { return nil }
        do {
            let pass = try PKPass(data: passData)
            lastPass = pass
            canAddToWallet = PKAddPassesViewController.canAddPasses()
            return pass
        } catch {
            print("PKPass creation failed: \(error). Using preview fallback.")
            return nil
        }
    }

    /// Builds an unsigned pass package for preview; real signing requires Apple Developer certs.
    private func buildPassPackage(metadata: WalletPassMetadata) -> Data? {
        let passJSON: [String: Any] = [
            "formatVersion": 1,
            "passTypeIdentifier": "pass.com.ayushcoder.clearswap.receipt",
            "teamIdentifier": "TEAMID",
            "organizationName": "ClearSwap",
            "description": "Verified Secondhand Receipt",
            "logoText": "ClearSwap",
            "foregroundColor": "rgb(255, 255, 255)",
            "backgroundColor": "rgb(15, 23, 30)",
            "labelColor": "rgb(180, 200, 190)",
            "serialNumber": metadata.serialNumber,
            "barcode": [
                "format": "PKBarcodeFormatQR",
                "message": metadata.dealID.uuidString,
                "messageEncoding": "iso-8859-1"
            ] as [String: Any],
            "generic": [
                "primaryFields": [
                    ["key": "item", "label": "ITEM", "value": metadata.itemTitle]
                ],
                "secondaryFields": [
                    ["key": "price", "label": "PAID", "value": CurrencyFormatting.string(from: metadata.amountPaid)],
                    ["key": "seller", "label": "SELLER", "value": metadata.sellerName]
                ],
                "auxiliaryFields": [
                    ["key": "serial", "label": "SERIAL", "value": metadata.serialNumber],
                    ["key": "warranty", "label": "WARRANTY UNTIL", "value": formatted(metadata.warrantyExpires)]
                ],
                "backFields": [
                    ["key": "buyer", "label": "Buyer", "value": metadata.buyerName],
                    ["key": "terms", "label": "Terms", "value": "30-day ClearSwap buyer protection. Present this pass for insurance or resale verification."]
                ]
            ] as [String: Any]
        ]

        guard JSONSerialization.isValidJSONObject(passJSON),
              let jsonData = try? JSONSerialization.data(withJSONObject: passJSON, options: [.prettyPrinted]) else {
            return nil
        }

        // Unsigned pass — PKPass init will fail without signature; preview UI handles this.
        return jsonData
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

struct WalletPassPreview: View {
    let metadata: WalletPassMetadata

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "wallet.pass.fill")
                    .foregroundStyle(CSColor.accent)
                Text("ClearSwap Verified Receipt")
                    .font(.headline)
                Spacer()
            }
            Text(metadata.itemTitle)
                .font(.title2.bold())
            HStack {
                VStack(alignment: .leading) {
                    Text("PAID")
                        .font(.caption2)
                        .foregroundStyle(CSColor.textSecondary)
                    Text(CurrencyFormatting.string(from: metadata.amountPaid))
                        .font(.title3.bold())
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("SERIAL")
                        .font(.caption2)
                        .foregroundStyle(CSColor.textSecondary)
                    Text(metadata.serialNumber)
                        .font(.caption.monospaced())
                }
            }
            Divider().overlay(CSColor.glassStroke)
            HStack {
                Label(metadata.sellerName, systemImage: "person.fill")
                Spacer()
                Label("30-Day Pass", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(CSColor.accent)
            }
            .font(.caption)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(CSColor.surface)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(CSColor.accent.opacity(0.4), lineWidth: 1))
        )
    }
}

struct AddPassViewControllerRepresentable: UIViewControllerRepresentable {
    let pass: PKPass
    var onFinish: () -> Void

    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        let vc = PKAddPassesViewController(pass: pass)!
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onFinish: onFinish) }

    final class Coordinator: NSObject, PKAddPassesViewControllerDelegate {
        let onFinish: () -> Void
        init(onFinish: @escaping () -> Void) { self.onFinish = onFinish }
        func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
            onFinish()
        }
    }
}
