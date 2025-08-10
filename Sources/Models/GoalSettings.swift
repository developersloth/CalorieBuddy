import Foundation
import SwiftData

@Model
final class GoalSettings {
    enum GoalType: String, Codable, CaseIterable { case maintain, lose, gain }
    var type: GoalType
    var dailyCalorieDelta: Int
    init(type: GoalType, dailyCalorieDelta: Int) { self.type = type; self.dailyCalorieDelta = dailyCalorieDelta }
}
