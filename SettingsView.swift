import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Daily Refill Reminder", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { newValue in
                        if newValue {
                            LocalNotificationManager.shared.scheduleDailyRefillReminder()
                        } else {
                            LocalNotificationManager.shared.cancelDailyRefillReminder()
                        }
                    }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            // Optionally refresh the state or re-request permission
            if notificationsEnabled {
                LocalNotificationManager.shared.requestAuthorization()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
