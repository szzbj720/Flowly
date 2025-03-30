import SwiftUI
import PhotosUI

struct EnhancedCustomizationView: View {
    @EnvironmentObject var settingsManager: UserSettingsManager
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    // Preset theme colors
    let presetColors: [String] = ["EEBA00", "FF6F61", "6B5B95", "88B04B", "F7CAC9"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Customize Your Profile")
                        .font(.largeTitle)
                        .bold()
                    
                    // Profile Picture Selection
                    VStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.keyColor, lineWidth: 4))
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Text("Tap to select")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                    // Theme Color Selection
                    VStack {
                        Text("Select a theme color:")
                            .font(.title2)
                        HStack {
                            ForEach(presetColors, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: settingsManager.settings.themeColorHex == hex ? 4 : 0)
                                    )
                                    .onTapGesture {
                                        settingsManager.settings.themeColorHex = hex
                                        settingsManager.saveSettings()
                                    }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile Customization")
        }
    }
}

struct EnhancedCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedCustomizationView()
            .environmentObject(UserSettingsManager())
    }
}
