import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    // Calculate the next milestone threshold (for demo: 10 then 50)
    var nextBadgeThreshold: Int {
        if progressManager.progress.refillCount < 10 {
            return 10
        } else if progressManager.progress.refillCount < 50 {
            return 50
        } else {
            return progressManager.progress.refillCount // Already beyond milestones
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Profile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                // Animated counters for key stats
                HStack {
                    Spacer()
                    VStack {
                        Text("Refills")
                        AnimatedCounter(value: Double(progressManager.progress.refillCount), font: .title)
                    }
                    Spacer()
                    VStack {
                        Text("Points")
                        AnimatedCounter(value: Double(progressManager.progress.points), font: .title)
                    }
                    Spacer()
                    VStack {
                        Text("Streak")
                        AnimatedCounter(value: Double(progressManager.progress.currentStreak), font: .title)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                
                // Progress toward next badge milestone
                VStack {
                    Text("Progress to next badge (\(nextBadgeThreshold) refills)")
                        .foregroundColor(.white)
                    ProgressView(value: Double(progressManager.progress.refillCount),
                                 total: Double(nextBadgeThreshold))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.keyColor))
                    .padding()
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                
                // Unlocked badges
                Text("Badges Unlocked:")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                if progressManager.progress.badges.isEmpty {
                    Text("No badges yet.")
                        .foregroundColor(.white)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(progressManager.progress.badges, id: \.self) { badge in
                                BadgeView(badge: badge)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.4))
            )
            .padding()
        }
        .background(
            Image("ProfileBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ProgressManager())
    }
}
