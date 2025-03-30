import SwiftUI

struct AccessibleButtonModifier: ViewModifier {
    let label: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(Text(label))
            .accessibilityAddTraits(.isButton)
        // Additional high-contrast trait
            .accessibilityAddTraits(.isHeader)
        // Optional adjustable action
            .accessibilityAdjustableAction { direction in
                // Insert custom action here, if needed
            }
    }
}

extension View {
    func accessibleButton(with label: String) -> some View {
        self.modifier(AccessibleButtonModifier(label: label))
    }
}
