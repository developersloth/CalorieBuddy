import Foundation
import SwiftData

@MainActor
final class OnboardingVM: ObservableObject {
    @Published var name = ""
    @Published var sex: UserProfile.Sex = .male
    @Published var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: .now)!
    @Published var height: Double = 175
    @Published var weight: Double = 70
    @Published var units: UserProfile.Units = .metric
    @Published var activity: UserProfile.ActivityLevel = .moderatelyActive
    @Published var syncICloud: Bool = false

    func createProfile(context: ModelContext) throws {
        let (heightCm, weightKg) = convertToMetric(height: height, weight: weight, units: units)
        let profile = UserProfile(name: name.isEmpty ? "Me" : name, sex: sex, birthDate: birthDate, heightCm: heightCm, weightKg: weightKg, activityLevel: activity, units: units)
        profile.syncWithICloud = syncICloud
        context.insert(profile)
        try context.save()
    }
    private func convertToMetric(height: Double, weight: Double, units: UserProfile.Units) -> (Double, Double) {
        if units == .metric { return (height, weight) }
        return (height * 2.54, weight * 0.45359237)
    }
}
