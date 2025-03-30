import SwiftUI

struct LiveLeaderboardEntry: Identifiable {
    let id = UUID()
    let name: String
    let refillCount: Int
}

class LiveLeaderboardManager: ObservableObject {
    @Published var leaderboard: [LiveLeaderboardEntry] = [
        LiveLeaderboardEntry(name: "Alice", refillCount: 120),
        LiveLeaderboardEntry(name: "Bob", refillCount: 95),
        LiveLeaderboardEntry(name: "Charlie", refillCount: 80)
    ]
    
    init() {
        // Simulate live updates every 10 seconds.
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.updateLeaderboard()
        }
    }
    
    func updateLeaderboard() {
        // Simulated update: add random values to refill counts.
        leaderboard = leaderboard.map { entry in
            let additionalRefills = Int.random(in: 0...5)
            return LiveLeaderboardEntry(name: entry.name, refillCount: entry.refillCount + additionalRefills)
        }
        leaderboard.sort { $0.refillCount > $1.refillCount }
    }
}

struct LiveLeaderboardView: View {
    @StateObject var leaderboardManager = LiveLeaderboardManager()
    
    var body: some View {
        NavigationStack {
            List(leaderboardManager.leaderboard) { entry in
                HStack {
                    Text(entry.name)
                        .font(.headline)
                    Spacer()
                    Text("\(entry.refillCount) Refills")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Live Leaderboard")
            .accessibilityLabel("Live Leaderboard showing top users and their refill counts")
        }
    }
}

struct LiveLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LiveLeaderboardView()
    }
}
