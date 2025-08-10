import Foundation
import SwiftData

struct ActivityLibraryLoader {
    struct Seed: Codable { let name: String; let category: ActivityItem.Category; let met: Double }
    static func loadBundledActivities(context: ModelContext) {
        guard let url = Bundle.main.url(forResource: "activity_library", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([Seed].self, from: data)
            for i in items { context.insert(ActivityItem(name: i.name, category: i.category, met: i.met)) }
            try context.save()
        } catch { print("Failed to load activity library: \(error)") }
    }
}
