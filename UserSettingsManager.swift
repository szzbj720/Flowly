import SwiftUI

class UserSettingsManager: ObservableObject {
    @Published var settings: UserSettings
    
    init() {
        if let saved = UserSettingsManager.loadSettings() {
            settings = saved
        } else {
            // Default theme color is set to our keyColor hex.
            settings = UserSettings(themeColorHex: "EEBA00", profileImageData: nil)
        }
    }
    
    func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "UserSettings")
        }
    }
    
    static func loadSettings() -> UserSettings? {
        if let data = UserDefaults.standard.data(forKey: "UserSettings"),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            return settings
        }
        return nil
    }
}


