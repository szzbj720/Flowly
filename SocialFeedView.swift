import SwiftUI

struct SocialFeedView: View {
    @State private var posts: [SocialPost] = [
        SocialPost(user: "Alice", message: "Just logged 5 refills today! #Sustainable", timestamp: Date()),
        SocialPost(user: "Bob", message: "Loving my new eco-friendly bottle! #GreenLife", timestamp: Date().addingTimeInterval(-3600)),
        SocialPost(user: "Charlie", message: "Every refill counts. Let's make a change!", timestamp: Date().addingTimeInterval(-7200)),
        SocialPost(user: "Dana", message: "Just hit 50 refills! Feeling proud 🌍", timestamp: Date().addingTimeInterval(-10800)),
        SocialPost(user: "Eli", message: "Refilled at my local coffee shop today. Support local!", timestamp: Date().addingTimeInterval(-14400)),
        SocialPost(user: "Faye", message: "My kid reminded me to bring my bottle 😄 #GreenFamily", timestamp: Date().addingTimeInterval(-18000))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts) { post in
                        SocialPostCardView(post: post)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Social Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SocialPostCreationView(posts: $posts)) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.keyColor)
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}


