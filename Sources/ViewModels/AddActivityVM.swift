import Foundation
import SwiftData

@MainActor
final class AddActivityVM: ObservableObject {
    @Published var query: String = ""
    @Published var results: [ActivityItem] = []
    @Published var minutes: Int = 30

    let context: ModelContext

    init(context: ModelContext) { self.context = context; search() }

    func search() {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            results = (try? context.fetch(FetchDescriptor<ActivityItem>())) ?? []
        } else {
            let q = query.lowercased()
            let pred = #Predicate<ActivityItem> { $0.name.lowercased().contains(q) }
            results = (try? context.fetch(FetchDescriptor<ActivityItem>(predicate: pred))) ?? []
        }
    }
    func addLog(for activity: ActivityItem, date: Date = .now) { let log = ActivityLog(date: date, activity: activity, minutes: minutes); context.insert(log); try? context.save() }
}
