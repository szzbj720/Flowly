import SwiftUI

struct AnimatedCounter: View, Animatable {
    var value: Double
    var font: Font = .title
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var body: some View {
        Text("\(Int(value))")
            .font(font)
            .foregroundColor(.white)
    }
}

struct AnimatedCounter_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCounter(value: 42)
    }
}
