import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

enum QRCodeService {
    private static let context = CIContext()
    private static let filter = CIFilter.qrCodeGenerator()

    static func generateImage(from string: String, size: CGFloat = 280) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        filter.message = data
        filter.correctionLevel = "H"
        guard let output = filter.outputImage else { return nil }

        let scale = size / output.extent.width
        let scaled = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    static func payload(for deal: Deal, hash: String) -> QRPayload {
        QRPayload(
            dealID: deal.id,
            releaseHash: hash,
            expiresAt: Date().addingTimeInterval(300),
            amount: deal.agreedPrice
        )
    }
}

struct QRCodeView: View {
    let payload: String
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            image = QRCodeService.generateImage(from: payload)
        }
        .onChange(of: payload) { _, newValue in
            image = QRCodeService.generateImage(from: newValue)
        }
    }
}
