import SwiftUI

struct ImpactView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    var plasticBottlesSaved: Int {
        progressManager.progress.refillCount
    }
    
    @State private var goal: Int = 100
    var milestone: Int = 50
    
    let ecoTips = [
        "Bring your own water bottle to avoid plastic waste.",
        "Refill instead of rebuy!",
        "One small habit can make a big environmental impact.",
        "Reduce. Reuse. Refill.",
        "Plastic takes 450 years to decompose!"
    ]
    
    var randomTip: String {
        ecoTips.randomElement() ?? ""
    }
    
    var progressColor: Color {
        switch plasticBottlesSaved {
        case 0..<25: return .green
        case 25..<50: return .yellow
        case 50..<75: return .orange
        default: return .red
        }
    }
    
    func rewardMilestones() {
        let milestones = [100, 300, 500, 1000]
        for milestone in milestones {
            if plasticBottlesSaved >= milestone && !progressManager.progress.badges.contains("\(milestone) Refills Reward") {
                progressManager.progress.points += 50
                progressManager.progress.badges.append("\(milestone) Refills Reward")
                progressManager.saveProgress()
            }
        }
    }
    
    func updateGoal() {
        let milestones = [100, 300, 500, 1000, 1500, 2000]
        for milestone in milestones where plasticBottlesSaved < milestone {
            goal = milestone
            return
        }
        goal = plasticBottlesSaved + 100
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Your Environmental Impact")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .accessibilityLabel("Your Environmental Impact")
            
            Text("Every refill you log helps reduce plastic pollution and protects wildlife habitats. Together, we can minimize landfill waste and conserve resources for future generations. You're helping create a cleaner ocean, safer ecosystems, and a more sustainable planet.")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel("Environmental benefit explanation")
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: min(CGFloat(plasticBottlesSaved) / CGFloat(goal), 1.0))
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: plasticBottlesSaved)
                
                VStack {
                    AnimatedCounter(value: Double(plasticBottlesSaved), font: .system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    Text("Bottles Saved")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 220, height: 220)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Circular progress indicator showing your impact")
            
            if plasticBottlesSaved >= milestone {
                Text("🎉 You've hit a milestone! Keep going! 🎉")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .transition(.scale)
            }
            
            VStack(alignment: .leading) {
                Text("Progress to \(goal) bottles:")
                    .foregroundColor(.white)
                    .font(.subheadline)
                ProgressView(value: Double(plasticBottlesSaved), total: Double(goal))
                    .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(.horizontal)
            
            Text("💡 \(randomTip)")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel("Eco Tip: \(randomTip)")
            
            Spacer()
        }
        .onAppear {
            rewardMilestones()
            updateGoal()
        }
        .onChange(of: plasticBottlesSaved) {
            rewardMilestones()
            updateGoal()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
        )
        .padding()
        .background(
            Image("ImpactBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))
        )
    }
}

struct ImpactView_Previews: PreviewProvider {
    static var previews: some View {
        ImpactView().environmentObject(ProgressManager())
    }
}
