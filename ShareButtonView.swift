import SwiftUI
import UIKit

struct ShareButtonView: UIViewControllerRepresentable {
    let shareText: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed.
    }
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView(shareText: "I've logged \(42) refills on Flowly! Join me in making a difference.")
    }
}



