import Foundation
import SwiftData

@MainActor
final class DashboardVM: ObservableObject {
    @Published var todayLogs: [FoodLog] = []
    @Published var todayCalories: Int = 0
    @Published var dailyTarget: Int = 0
    @Published var weekSeries: [(Date, Int)] = []
    @Published var todayBurned: Int = 0
    @Published var netCalories: Int = 0

    private let context: ModelContext
    private let calendar: Calendar = .current
    private var profile: UserProfile?

    init(context: ModelContext) {
        self.context = context
        self.profile = try? context.fetch(FetchDescriptor<UserProfile>()).first
        reloadAll()
    }

    func reloadAll() { loadToday(); computeTarget(); loadActivityToday(); loadWeek() }

    func loadToday() {
        let today = Date().stripTimeToLocalDay()
        let pred = #Predicate<FoodLog> { $0.date == today }
        todayLogs = (try? context.fetch(FetchDescriptor<FoodLog>(predicate: pred))) ?? []
        todayCalories = Int(todayLogs.reduce(0) { $0 + $1.calories })
    }
    func computeTarget() { guard let profile else { dailyTarget = 0; return }; dailyTarget = TDEECalculator.dailyTargetCalories(for: profile) }

    func loadActivityToday() {
        let today = Date().stripTimeToLocalDay()
        let pred = #Predicate<ActivityLog> { $0.date == today }
        let logs = (try? context.fetch(FetchDescriptor<ActivityLog>(predicate: pred))) ?? []
        let weightKg = (try? context.fetch(FetchDescriptor<UserProfile>()).first?.weightKg) ?? 70
        todayBurned = logs.reduce(0) { $0 + ActivityEnergyCalculator.calories(met: $1.activity.met, weightKg: weightKg, minutes: $1.minutes) }
        netCalories = todayCalories - todayBurned
    }

    func loadWeek() {
        let today = Date().stripTimeToLocalDay()
        var series: [(Date, Int)] = []
        for i in (0..<7).reversed() {
            let d = calendar.date(byAdding: .day, value: -i, to: today)!.stripTimeToLocalDay()
            let pred = #Predicate<FoodLog> { $0.date == d }
            let logs = (try? context.fetch(FetchDescriptor<FoodLog>(predicate: pred))) ?? []
            let sum = Int(logs.reduce(0) { $0 + $1.calories })
            series.append((d, sum))
        }
        weekSeries = series
    }

    func deleteLog(_ log: FoodLog) { context.delete(log); try? context.save(); reloadAll() }
}
