import SwiftUI

struct ResourceOverlayView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            VStack(spacing: 20) {
                Text("Resources")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .accessibilityLabel("Resources")
                
                Text("""
Advocating for a sustainable future and less plastic use:

• Plastic Pollution Coalition – www.plasticpollutioncoalition.org  
• Ocean Conservancy – www.oceanconservancy.org  
• Surfrider Foundation – www.surfrider.org  
• Environmental Defense Fund – www.edf.org  
• Greenpeace – www.greenpeace.org  
• The Story of Stuff Project – www.storyofstuff.org
""")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                )
                .accessibilityLabel("Resources: Plastic Pollution Coalition, Ocean Conservancy, Surfrider Foundation, Environmental Defense Fund, Greenpeace, The Story of Stuff Project")
                
                Button(action: {
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Text("Close")
                        .font(.headline)
                        .padding()
                        .frame(width: 200)
                        .background(Color.keyColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .accessibleButton(with: "Close support overlay")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.95))
            )
            .shadow(radius: 10)
            .padding()
        }
        .transition(.opacity)
    }
}

