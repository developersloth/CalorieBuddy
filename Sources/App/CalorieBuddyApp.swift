import SwiftUI
import SwiftData

@main
struct CalorieBuddyApp: App {
    var body: some Scene {
        WindowGroup { NavigationStack { RootView() } }
            .modelContainer(sharedContainer)
    }
}

var sharedContainer: ModelContainer = {
    let schema = Schema([UserProfile.self, GoalSettings.self, FoodItem.self, FoodLog.self, ActivityItem.self, ActivityLog.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        let container = try ModelContainer(for: schema, configurations: config)
        let context = ModelContext(container)
        let foodCount = try context.fetchCount(FetchDescriptor<FoodItem>())
        if foodCount == 0 { FoodLibraryLoader.loadBundledFoods(context: context) }
        let actCount = try context.fetchCount(FetchDescriptor<ActivityItem>())
        if actCount == 0 { ActivityLibraryLoader.loadBundledActivities(context: context) }
        return container
    } catch { fatalError("Failed to create container: \(error)") }
}()
