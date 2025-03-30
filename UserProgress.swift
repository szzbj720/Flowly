import Foundation

struct UserProgress: Codable {
    var refillCount: Int          // Total number of water bottle refills
    var points: Int               // Total points earned from refills
    var badges: [String]          // List of badges unlocked
    var lastRefillDate: Date?     // Date of the last logged refill
    var currentStreak: Int        // Current consecutive refill streak
    var refillHistory: [Date]     // Log of all refill events
    
    // Optional helper method to update progress (if needed)
    mutating func updateForNewRefill() {
        refillCount += 1
        points += 10 // Example: 10 points per refill
        
        let now = Date()
        if let lastDate = lastRefillDate, Calendar.current.isDateInYesterday(lastDate) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        lastRefillDate = now
        
        // Record the refill event
        refillHistory.append(now)
        
        // Badge unlocking logic:
        if refillCount == 10 && !badges.contains("10 Refills Badge") {
            badges.append("10 Refills Badge")
        }
        // Add more badge rules as needed...
    }
}


