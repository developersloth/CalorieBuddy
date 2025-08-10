import Foundation

enum ActivityEnergyCalculator {
    static func calories(met: Double, weightKg: Double, minutes: Int) -> Int {
        let kcal = (met * 3.5 * weightKg / 200.0) * Double(minutes)
        return Int(round(kcal))
    }
}
