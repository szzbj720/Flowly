import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("boy")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                // Existing FlowlyContentView content
                FlowlyContentView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
