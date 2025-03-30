import SwiftUI

struct CustomizationView: View {
    @EnvironmentObject var settingsManager: UserSettingsManager
    @State private var selectedColor: String
    @State private var showColorName: String = ""
    
    let presetColors: [(name: String, hex: String)] = [
        ("Sunshine Yellow", "EEBA00"),
        ("Coral Red", "FF6F61"),
        ("Lavender Purple", "6B5B95"),
        ("Mint Green", "88B04B"),
        ("Blush Pink", "F7CAC9")
    ]
    
    init() {
        // Default to current theme
        _selectedColor = State(initialValue: UserSettingsManager().settings.themeColorHex)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Customize Your Theme")
                    .font(.system(size: 34, weight: .bold))
                
                Text("Select a theme color:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Animated Color Picker
                HStack(spacing: 20) {
                    ForEach(presetColors, id: \.hex) { (name, hex) in
                        ZStack {
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 60, height: 60)
                                .scaleEffect(selectedColor == hex ? 1.2 : 1.0)
                                .shadow(color: selectedColor == hex ? Color(hex: hex).opacity(0.6) : .clear, radius: 10)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == hex ? 4 : 0)
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedColor = hex
                                        settingsManager.settings.themeColorHex = hex
                                        settingsManager.saveSettings()
                                        showColorName = name
                                    }
                                }
                            
                            if selectedColor == hex {
                                Text("✓")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityLabel("\(name) theme color")
                    }
                }
                .padding(.bottom, 10)
                
                // Tooltip-style color name
                if !showColorName.isEmpty {
                    Text("Selected: \(showColorName)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .transition(.opacity)
                }
                
                Divider()
                
                // Live Preview Box
                VStack(spacing: 12) {
                    Text("Live Preview")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: selectedColor))
                        .frame(height: 50)
                        .overlay(Text("Theme Preview").foregroundColor(.white))
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Customization")
        }
    }
}

struct CustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationView().environmentObject(UserSettingsManager())
    }
}
