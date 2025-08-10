import Foundation
import SwiftData

@Model
final class UserProfile {
    enum Sex: String, Codable, CaseIterable { case male, female }
    enum ActivityLevel: String, Codable, CaseIterable { case sedentary, lightlyActive, moderatelyActive, veryActive, extraActive }
    enum Units: String, Codable, CaseIterable { case metric, imperial }

    var name: String
    var sex: Sex
    var birthDate: Date
    var heightCm: Double
    var weightKg: Double
    var activityLevel: ActivityLevel
    var units: Units
    var createdAt: Date = .now
    var updatedAt: Date = .now
    var syncWithICloud: Bool = false
    var goal: GoalSettings?

    init(name: String, sex: Sex, birthDate: Date, heightCm: Double, weightKg: Double, activityLevel: ActivityLevel, units: Units = .metric) {
        self.name = name
        self.sex = sex
        self.birthDate = birthDate
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.activityLevel = activityLevel
        self.units = units
    }
}
