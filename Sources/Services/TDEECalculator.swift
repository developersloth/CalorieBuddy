import Foundation

struct TDEECalculator {
    static func age(from birthDate: Date, now: Date = .now, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.year], from: birthDate, to: now).year ?? 30
    }
    static func bmr(sex: UserProfile.Sex, age: Int, weightKg: Double, heightCm: Double) -> Double {
        let base = 10 * weightKg + 6.25 * heightCm - 5 * Double(age)
        return base + (sex == .male ? 5 : -161)
    }
    static func activityMultiplier(_ level: UserProfile.ActivityLevel) -> Double {
        switch level { case .sedentary: 1.2; case .lightlyActive: 1.375; case .moderatelyActive: 1.55; case .veryActive: 1.725; case .extraActive: 1.9 }
    }
    static func maintenanceCalories(for profile: UserProfile, at date: Date = .now) -> Int {
        let a = age(from: profile.birthDate, now: date)
        let cals = bmr(sex: profile.sex, age: a, weightKg: profile.weightKg, heightCm: profile.heightCm) * activityMultiplier(profile.activityLevel)
        return Int(round(cals))
    }
    static func dailyTargetCalories(for profile: UserProfile, at date: Date = .now) -> Int {
        let maintain = maintenanceCalories(for: profile, at: date)
        if let goal = profile.goal { return max(0, maintain + goal.dailyCalorieDelta) }
        return maintain
    }
}
