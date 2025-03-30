import SwiftUI

struct SocialPostCreationView: View {
    @Binding var posts: [SocialPost]
    @State private var postText: String = ""
    
    var body: some View {
        VStack {
            Text("Create a Post")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextEditor(text: $postText)
                .frame(height: 200)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                let trimmed = postText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    let newPost = SocialPost(user: "You", message: trimmed, timestamp: Date())
                    posts.insert(newPost, at: 0)
                    postText = ""
                }
            }) {
                Text("Post")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.keyColor)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("New Post")
        .background(Color.white.ignoresSafeArea())
    }
}

