import Foundation
import SwiftData

@Model
final class ActivityLog {
    var id: UUID = UUID()
    var date: Date
    @Relationship var activity: ActivityItem
    var minutes: Int
    var notes: String?
    init(date: Date, activity: ActivityItem, minutes: Int, notes: String? = nil) {
        self.date = date.stripTimeToLocalDay(); self.activity = activity; self.minutes = minutes; self.notes = notes
    }
}
