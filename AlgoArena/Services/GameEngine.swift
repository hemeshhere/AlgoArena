import UIKit

class GameEngine {
    static let shared = GameEngine()
    private let defaults = UserDefaults.standard
    
    // Storage Keys
    private let eloKey = "userEloRating"
    private let streakKey = "userDailyStreak"
    private let usernameKey = "username"
    private let avatarKey = "avatarName"
    private let lastPlayedKey = "lastPlayedDate"
    private let activityHistoryKey = "activityHistory"
    private let unlockedBadgesKey = "unlockedBadges"
    
    private init() {}
    
    var username: String {
        get { return defaults.string(forKey: usernameKey) ?? "" }
        set { defaults.set(newValue, forKey: usernameKey) }
    }
    
    var avatarName: String {
        get { return defaults.string(forKey: avatarKey) ?? "person.crop.circle.fill" }
        set { defaults.set(newValue, forKey: avatarKey) }
    }
    
    var eloRating: Int {
        get {
            let rating = defaults.integer(forKey: eloKey)
            return rating == 0 ? 1200 : rating
        }
        set { defaults.set(newValue, forKey: eloKey) }
    }
    
    var currentStreak: Int {
        get { return defaults.integer(forKey: streakKey) }
        set { defaults.set(newValue, forKey: streakKey) }
    }
    
    var lastPlayedDate: Date? {
        get { return defaults.object(forKey: lastPlayedKey) as? Date }
        set { defaults.set(newValue, forKey: lastPlayedKey) }
    }
    
    // Maps a date string like "2026-10-23" to a boolean indicating activity
    var activityHistory: [String: Bool] {
        get { return defaults.dictionary(forKey: activityHistoryKey) as? [String: Bool] ?? [:] }
        set { defaults.set(newValue, forKey: activityHistoryKey) }
    }
    
    // Stores the string IDs of badges the user has earned
    var unlockedBadges: [String] {
        get { return defaults.stringArray(forKey: unlockedBadgesKey) ?? [] }
        set { defaults.set(newValue, forKey: unlockedBadgesKey) }
    }
    
    func getRankTitle() -> String {
        switch eloRating {
        case ..<1400: return "Newbie"
        case 1400..<1600: return "Pupil"
        case 1600..<1900: return "Specialist"
        default: return "Candidate Master"
        }
    }
    
    func getRankColor() -> UIColor {
        switch eloRating {
        case ..<1400: return UIColor.systemTeal
        case 1400..<1600: return UIColor.systemGreen
        case 1600..<1900: return UIColor.systemBlue
        default: return UIColor.systemPurple
        }
    }
    
    func unlockBadge(id: String) -> Bool {
        var current = unlockedBadges
        if !current.contains(id) {
            current.append(id)
            unlockedBadges = current
            return true
        }
        return false
    }
    
    /// Records quiz completion, updates streak, elo, and unlocks any relevant achievements.
    @discardableResult
    func recordQuizResult(score: Int, total: Int, topicTitle: String) -> (eloChange: Int, newBadges: [String]) {
        // Base Elo calculation: +10 per correct answer, -5 for wrong answers (floor at 1000)
        let delta = (score * 12) - ((total - score) * 4)
        eloRating = max(1000, eloRating + delta)
        
        // Update Streak & Activity
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayKey = formatter.string(from: today)
        
        var history = activityHistory
        history[todayKey] = true
        activityHistory = history
        
        if let last = lastPlayedDate {
            if calendar.isDateInYesterday(last) {
                currentStreak += 1
            } else if !calendar.isDateInToday(last) {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        lastPlayedDate = today
        
        // Check achievements
        var newlyUnlocked: [String] = []
        if unlockBadge(id: "first_blitz") { newlyUnlocked.append("first_blitz") }
        if currentStreak >= 3, unlockBadge(id: "streak_3") { newlyUnlocked.append("streak_3") }
        if eloRating >= 1400, unlockBadge(id: "pupil_rank") { newlyUnlocked.append("pupil_rank") }
        if eloRating >= 1600, unlockBadge(id: "specialist_rank") { newlyUnlocked.append("specialist_rank") }
        if score == total && total > 0, unlockBadge(id: "perfect_score") { newlyUnlocked.append("perfect_score") }
        if topicTitle.lowercased().contains("tree") || topicTitle.lowercased().contains("graph") {
            if unlockBadge(id: "tree_master") { newlyUnlocked.append("tree_master") }
        }
        
        return (delta, newlyUnlocked)
    }
    
    func resetProgress() {
        username = ""
        eloRating = 1200
        currentStreak = 0
        lastPlayedDate = nil
        activityHistory = [:]
        unlockedBadges = []
    }
}
