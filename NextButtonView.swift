import SwiftUI

struct NextButtonView: View {
    var destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text("Next")
                Image(systemName: "arrow.forward")
            }
            .font(.title2)
            .padding()
            .background(Color.keyColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

