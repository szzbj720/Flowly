import SwiftUI

struct PrevButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.backward")
                Text("Back")
            }
            .font(.title2)
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
        }
    }
}


