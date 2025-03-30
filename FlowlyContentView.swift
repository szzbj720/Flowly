import SwiftUI

// MARK: - Data Model for Bubble Buttons
struct BubbleItem: Identifiable {
    let id = UUID()
    let label: String
    let xOffset: CGFloat  // Relative horizontal position (0.0 to 1.0)
    let yOffset: CGFloat  // Relative vertical position (0.0 to 1.0)
    let destination: AnyView
}

// MARK: - Custom Bubble Button Style
struct BubbleButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Marker Felt", size: 13))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(width: 75, height: 75)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        backgroundColor.opacity(0.6),
                        backgroundColor
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 40
                )
            )
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white.opacity(0.8), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: backgroundColor.opacity(0.4), radius: 4, x: 0, y: 3)
    }
}

// MARK: - Main View with Floating Bubble Buttons & Dynamic Theme
struct FlowlyContentView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var settingsManager: UserSettingsManager
    @State private var showSupport = false
    @State private var showCheatingAlert = false
    
    var dynamicBubbleItems: [BubbleItem] {
        return [
            BubbleItem(label: "Log Refill", xOffset: 0.17, yOffset: 0.28, destination: AnyView(EmptyView())),
            BubbleItem(label: "Profile", xOffset: 0.85, yOffset: 0.25, destination: AnyView(ProfileView())),
            BubbleItem(label: "Impact", xOffset: 0.19, yOffset: 0.46, destination: AnyView(ImpactView())),
            BubbleItem(label: "Leaderboard", xOffset: 0.2, yOffset: 0.7, destination: AnyView(LeaderboardView())),
            BubbleItem(label: "Theme", xOffset: 0.2, yOffset: 0.9, destination: AnyView(CustomizationView())),
            BubbleItem(label: "Daily", xOffset: 0.5, yOffset: 0.4, destination: AnyView(DailyChallengeView())),
            BubbleItem(label: "Rewards", xOffset: 0.8, yOffset: 0.7, destination: AnyView(RewardsStoreView())),
            BubbleItem(label: "Social", xOffset: 0.8, yOffset: 0.4, destination: AnyView(SocialFeedView())),
            BubbleItem(label: "Resources", xOffset: 0.8, yOffset: 0.9, destination: AnyView(EmptyView()))
        ]
    }
    
    var currentThemeColor: Color {
        Color.themeColor(from: settingsManager.settings)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("boy")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 8) {
                    Text("Flowly")
                        .font(.custom("Chalkduster", size: 80))
                        .foregroundColor(.black)
                        .padding(.top, 60)
                    
                    VStack(spacing: 10) {
                        Text("Total Refills: \(progressManager.progress.refillCount)")
                        Text("Points: \(progressManager.progress.points)")
                        Text("Streak: \(progressManager.progress.currentStreak) days")
                    }
                    .font(.custom("Marker Felt", size: 25))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5]))
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                
                ForEach(dynamicBubbleItems) { bubble in
                    if bubble.label == "Log Refill" {
                        Button(bubble.label) {
                            let success = progressManager.logRefill()
                            if !success {
                                showCheatingAlert = true
                            }
                        }
                        .buttonStyle(BubbleButtonStyle(backgroundColor: currentThemeColor))
                        .offset(
                            x: bubble.xOffset * geometry.size.width - geometry.size.width / 2,
                            y: bubble.yOffset * geometry.size.height - geometry.size.height / 2
                        )
                        .accessibleButton(with: bubble.label)
                    } else if bubble.label == "Resources" {
                        Button(bubble.label) {
                            withAnimation {
                                showSupport.toggle()
                            }
                        }
                        .buttonStyle(BubbleButtonStyle(backgroundColor: currentThemeColor))
                        .offset(
                            x: bubble.xOffset * geometry.size.width - geometry.size.width / 2,
                            y: bubble.yOffset * geometry.size.height - geometry.size.height / 2
                        )
                        .accessibleButton(with: "Need Resources")
                    } else {
                        NavigationLink(destination: bubble.destination) {
                            Text(bubble.label)
                        }
                        .buttonStyle(BubbleButtonStyle(backgroundColor: currentThemeColor))
                        .offset(
                            x: bubble.xOffset * geometry.size.width - geometry.size.width / 2,
                            y: bubble.yOffset * geometry.size.height - geometry.size.height / 2
                        )
                        .accessibleButton(with: bubble.label)
                    }
                }
                
                if showSupport {
                    ResourceOverlayView(isShowing: $showSupport)
                }
            }
            .alert(isPresented: $showCheatingAlert) {
                Alert(
                    title: Text("Refill too soon!"),
                    message: Text("Please wait a bit before logging another refill."),
                    dismissButton: .default(Text("Got it"))
                )
            }
        }
    }
}

struct FlowlyContentView_Previews: PreviewProvider {
    static var previews: some View {
        FlowlyContentView()
            .environmentObject(ProgressManager())
            .environmentObject(UserSettingsManager())
            .previewDevice("iPhone 16 Pro Max")
    }
}
