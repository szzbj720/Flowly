import SwiftUI

struct SocialPostCardView: View {
    let post: SocialPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(post.user, systemImage: "person.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(post.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(post.message)
                .font(.body)
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            HStack(spacing: 16) {
                Label("💧 Hydrate", systemImage: "drop.fill")
                Label("❤️ Like", systemImage: "heart.fill")
                Label("🌿 Eco+", systemImage: "leaf.fill")
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}



