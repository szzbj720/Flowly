import SwiftUI

extension Color {
    /// Returns the current theme color based on the user's settings.
    static func themeColor(from settings: UserSettings) -> Color {
        return Color(hex: settings.themeColorHex)
    }
}
