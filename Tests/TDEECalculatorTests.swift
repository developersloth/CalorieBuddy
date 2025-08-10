import XCTest
@testable import CalorieBuddy

final class TDEECalculatorTests: XCTestCase {
    func testBMRMale() { let bmr = TDEECalculator.bmr(sex: .male, age: 30, weightKg: 70, heightCm: 175); XCTAssertEqual(Int(round(bmr)), 1674) }
    func testDailyTargetDelta() {
        let profile = UserProfile(name: "Test", sex: .female, birthDate: Calendar.current.date(byAdding: .year, value: -28, to: .now)!, heightCm: 165, weightKg: 60, activityLevel: .lightlyActive, units: .metric)
        profile.goal = GoalSettings(type: .lose, dailyCalorieDelta: -500)
        let target = TDEECalculator.dailyTargetCalories(for: profile)
        let maintain = TDEECalculator.maintenanceCalories(for: profile)
        XCTAssertEqual(target, max(0, maintain - 500))
    }
}
