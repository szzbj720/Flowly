import SwiftUI

struct DailyChallenge: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var prerequisite: () -> Bool // Add prerequisite check
}

class ChallengeManager: ObservableObject {
    @Published var challenges: [DailyChallenge] = []
    @Published var lastCompletionDates: [UUID: Date] = [:]
    
    func setupChallenges(using progressManager: ProgressManager) {
        challenges = [
            DailyChallenge(title: "Daily Refill",
                           description: "Log a refill today to earn bonus points!",
                           isCompleted: false,
                           prerequisite: {
                               progressManager.progress.refillCount > 0
                           }),
            
            DailyChallenge(title: "Avoid Plastic",
                           description: "Don't redeem any points today to complete this challenge.",
                           isCompleted: false,
                           prerequisite: {
                               progressManager.progress.points < 200
                           }),
            
            DailyChallenge(title: "Refill Reminder",
                           description: "Have at least one refill in the last 24 hours.",
                           isCompleted: false,
                           prerequisite: {
                               if let last = progressManager.progress.lastRefillDate {
                                   return Calendar.current.isDateInToday(last)
                               }
                               return false
                           }),
            
            DailyChallenge(title: "Streak Master",
                           description: "Maintain a streak of 3 or more days!",
                           isCompleted: false,
                           prerequisite: {
                               progressManager.progress.currentStreak >= 3
                           }),
            
            DailyChallenge(title: "Early Bird",
                           description: "Log a refill before 10 AM today.",
                           isCompleted: false,
                           prerequisite: {
                               if let last = progressManager.progress.lastRefillDate,
                                  Calendar.current.isDateInToday(last) {
                                   let hour = Calendar.current.component(.hour, from: last)
                                   return hour < 10
                               }
                               return false
                           }),
            
            DailyChallenge(title: "Hydration Hero",
                           description: "Log at least 3 refills today.",
                           isCompleted: false,
                           prerequisite: {
                               let today = Date()
                               let todayRefills = progressManager.progress.refillHistory.filter {
                                   Calendar.current.isDate($0, inSameDayAs: today)
                               }
                               return todayRefills.count >= 3
                           })
        ]
    }

    
    func completeChallenge(_ challenge: DailyChallenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isCompleted = true
            lastCompletionDates[challenge.id] = Date()
        }
    }
    
    func resetIfNeeded() {
        for index in challenges.indices {
            if let lastDate = lastCompletionDates[challenges[index].id],
               !Calendar.current.isDate(lastDate, inSameDayAs: Date()) {
                challenges[index].isCompleted = false
            }
        }
    }
}

struct DailyChallengeView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject var challengeManager = ChallengeManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Daily Challenges")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top)
                
                ForEach(challengeManager.challenges) { challenge in
                    VStack(spacing: 12) {
                        Text(challenge.title)
                            .font(.title)
                            .bold()
                        
                        Text(challenge.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if challenge.isCompleted {
                            Text("✅ Challenge Completed")
                                .font(.headline)
                                .foregroundColor(.green)
                        } else {
                            Button(action: {
                                challengeManager.completeChallenge(challenge)
                                progressManager.progress.points += 15
                                progressManager.saveProgress()
                            }) {
                                Text("Complete Challenge")
                                    .font(.title2)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(challenge.prerequisite() ? Color.keyColor : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(!challenge.prerequisite() || challenge.isCompleted)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Daily Challenge")
        .onAppear {
            challengeManager.resetIfNeeded()
            challengeManager.setupChallenges(using: progressManager)
        }
    }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeView()
            .environmentObject(ProgressManager())
    }
}
