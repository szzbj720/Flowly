import SwiftUI

@main
struct FlowlyApp: App {
    @StateObject var progressManager = ProgressManager()
    @StateObject var settingsManager = UserSettingsManager()
    
    init() {
        // We only use sound effects, so no continuous background music.
        LocalNotificationManager.shared.requestAuthorization()
        LocalNotificationManager.shared.scheduleDailyRefillReminder()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environmentObject(progressManager)
            .environmentObject(settingsManager)
        }
    }
    
    
}

