import Foundation

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
        get { return defaults.string(forKey: avatarKey) ?? "person.circle.fill" }
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
}
