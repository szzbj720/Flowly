import Foundation

struct SocialPost: Identifiable {
    let id = UUID()
    let user: String
    let message: String
    let timestamp: Date
}



