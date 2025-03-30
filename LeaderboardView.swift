import SwiftUI

struct LeaderboardEntry: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let refillCount: Int
}

struct LeaderboardView: View {
    @EnvironmentObject var progressManager: ProgressManager
    let staticLeaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(name: "Alice", refillCount: 120),
        LeaderboardEntry(name: "Bob", refillCount: 95),
        LeaderboardEntry(name: "Charlie", refillCount: 8),
        LeaderboardEntry(name: "Diana", refillCount: 75),
        LeaderboardEntry(name: "Evan", refillCount: 270),
        LeaderboardEntry(name: "Faith", refillCount: 65),
        LeaderboardEntry(name: "George", refillCount: 60),
        LeaderboardEntry(name: "Hannah", refillCount: 587),
        LeaderboardEntry(name: "Ivan", refillCount: 56),
        LeaderboardEntry(name: "Jasmine", refillCount: 52),
        LeaderboardEntry(name: "Kyle", refillCount: 49),
        LeaderboardEntry(name: "Luna", refillCount: 47),
        LeaderboardEntry(name: "Mason", refillCount: 124),
        LeaderboardEntry(name: "Nina", refillCount: 42),
        LeaderboardEntry(name: "Owen", refillCount: 4),
        LeaderboardEntry(name: "Priya", refillCount: 38),
        LeaderboardEntry(name: "Quinn", refillCount: 0),
        LeaderboardEntry(name: "Riley", refillCount: 852),
        LeaderboardEntry(name: "Sam", refillCount: 30),
        LeaderboardEntry(name: "Tina", refillCount: 438)
    ]
    
    var leaderboard: [LeaderboardEntry] {
        let userEntry = LeaderboardEntry(name: "You", refillCount: progressManager.progress.refillCount)
        
        // Add user if not already in top leaderboard
        var allEntries = staticLeaderboard
        if !allEntries.contains(where: { $0.name == "You" }) {
            allEntries.append(userEntry)
        }
        
        return allEntries.sorted { $0.refillCount > $1.refillCount }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(leaderboard.indices, id: \.self) { index in
                        let entry = leaderboard[index]
                        LeaderboardRowView(entry: entry, rank: index + 1, isCurrentUser: entry.name == "You")
                    }
                }
                .padding()
            }
            .navigationTitle("🏆 Leaderboard")
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
            )
        }
    }
}

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    let rank: Int
    let isCurrentUser: Bool
    
    var medalIcon: String? {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return nil
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(medalIcon ?? "\(rank)")
                .font(.largeTitle)
            
            Circle()
                .fill(isCurrentUser ? Color.green : Color.keyColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(entry.name.prefix(1)))
                        .font(.title2)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(isCurrentUser ? .green : .primary)
                Text("\(entry.refillCount) Refills")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.6))
                .shadow(radius: 5)
        )
    }
}
