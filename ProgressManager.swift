import UserNotifications
import SwiftUI

class ProgressManager: ObservableObject {
    @Published var progress: UserProgress
    private let cooldownMinutes = 10  // ⏱ Adjust this to set cooldown time
    
    init() {
        if let saved = ProgressManager.loadProgress() {
            self.progress = saved
        } else {
            self.progress = UserProgress(refillCount: 0,
                                         points: 0,
                                         badges: [],
                                         lastRefillDate: nil,
                                         currentStreak: 0,
                                         refillHistory: [])
        }
    }
    
    func logRefill(withNotification: Bool = true) -> Bool {
        let now = Date()
        
        if let last = progress.lastRefillDate,
           let minutesSince = Calendar.current.dateComponents([.minute], from: last, to: now).minute,
           minutesSince < cooldownMinutes {
            if withNotification {
                sendCooldownWarning()
            }
            return false // Too soon!
        }
        
        //  Allowed to log refill
        progress.refillCount += 1
        progress.points += 10
        progress.lastRefillDate = now
        progress.refillHistory.append(now)
        
        // Handle streak
        if let last = progress.lastRefillDate {
            if Calendar.current.isDateInYesterday(last) {
                progress.currentStreak += 1
            } else if !Calendar.current.isDateInToday(last) {
                progress.currentStreak = 1
            }
        } else {
            progress.currentStreak = 1
        }
        
        // Badges
        if progress.refillCount == 10 && !progress.badges.contains("10 Refills") {
            progress.badges.append("10 Refills")
            SoundEffectManager.shared.playSoundEffect(named: "badgeUnlock")
        }
        if progress.refillCount == 50 && !progress.badges.contains("50 Refills") {
            progress.badges.append("50 Refills")
            SoundEffectManager.shared.playSoundEffect(named: "badgeUnlock")
        }
        
        SoundEffectManager.shared.playSoundEffect(named: "refillSound")
        saveProgress()
        return true
    }
    
    private func sendCooldownWarning() {
        let content = UNMutableNotificationContent()
        content.title = "⏱ Slow down!"
        content.body = "You just refilled recently. Try again later to earn points."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "refillCooldown", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
    func saveProgress() {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: "UserProgress")
        }
    }
    
    static func loadProgress() -> UserProgress? {
        if let data = UserDefaults.standard.data(forKey: "UserProgress"),
           let progress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            return progress
        }
        return nil
    }
    
    func resetProgress() {
        progress = UserProgress(refillCount: 0, points: 0, badges: [], lastRefillDate: nil, currentStreak: 0, refillHistory: [])
        saveProgress()
    }
    
}
