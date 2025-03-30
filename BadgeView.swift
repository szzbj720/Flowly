import SwiftUI

struct BadgeView: View {
    var badge: String
    @State private var scale: CGFloat = 0.0
    
    var badgeIconName: String {
        switch badge {
        case "10 Refills":
            return "drop.fill" // water drop
        case "50 Refills":
            return "trophy.fill" // trophy
        case "10 Refills Badge":
            return "star.fill"
        default:
            return "leaf.fill" // fallback symbol
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: badgeIconName)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding(20)
                .background(
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.keyColor, Color.keyColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                        )
                )
                .shadow(radius: 5)
                .scaleEffect(scale)
            
            Text(badge)
                .font(.caption)
                .foregroundColor(.white)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }
}
