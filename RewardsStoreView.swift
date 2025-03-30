import SwiftUI
import Foundation


struct Reward: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let cost: Int
    let icon: String // SF Symbol
    let tag: String? // Optional badge tag
}

class RewardsStoreManager: ObservableObject {
    @Published var rewards: [Reward] = [
        Reward(title: "Reusable Bottle", description: "Get a discount on a reusable bottle.", cost: 100, icon: "drop.fill", tag: "Popular"),
        Reward(title: "Eco-Friendly Tote", description: "Redeem points for an eco tote bag.", cost: 150, icon: "leaf.fill", tag: "Eco+"),
        Reward(title: "Sustainable Gift Card", description: "Exchange points for a gift card to an eco-friendly store.", cost: 200, icon: "giftcard", tag: "Rare")
    ]
    
    func redeem(reward: Reward, progressManager: ProgressManager) -> Bool {
        if progressManager.progress.points >= reward.cost {
            progressManager.progress.points -= reward.cost
            progressManager.saveProgress()
            return true
        } else {
            return false
        }
    }
}

struct RewardsStoreView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject var rewardsStoreManager = RewardsStoreManager()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            List(rewardsStoreManager.rewards) { reward in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: reward.icon)
                            .font(.largeTitle)
                            .foregroundColor(.keyColor)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(reward.title)
                                    .font(.headline)
                                if let tag = reward.tag {
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(4)
                                        .background(Color.green.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                            }
                            
                            Text(reward.description)
                                .font(.subheadline)
                            
                            HStack {
                                Text("Cost: \(reward.cost) points")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button(action: {
                                    if rewardsStoreManager.redeem(reward: reward, progressManager: progressManager) {
                                        alertMessage = "🎉 Redeemed \(reward.title) successfully!"
                                    } else {
                                        alertMessage = "Not enough points to redeem \(reward.title)."
                                    }
                                    showAlert = true
                                }) {
                                    Text("Redeem")
                                        .font(.headline)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.keyColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.keyColor.opacity(0.6), radius: 5, x: 0, y: 3)
                                }
                                .accessibleButton(with: "Redeem \(reward.title)")
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.keyColor.opacity(0.5), lineWidth: 2)
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Rewards Store")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Reward Redemption"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RewardsStoreView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsStoreView()
            .environmentObject(ProgressManager())
    }
}
