import Foundation
import SwiftData

@Model
final class ActivityItem {
    enum Category: String, Codable, CaseIterable { case cardio, sports, strength, lifestyle }
    var id: UUID = UUID()
    var name: String
    var category: Category
    var met: Double
    init(name: String, category: Category, met: Double) { self.name = name; self.category = category; self.met = met }
}
