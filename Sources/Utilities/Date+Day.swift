import Foundation

extension Date {
    func stripTimeToLocalDay(calendar: Calendar = .current) -> Date {
        let comps = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: comps) ?? self
    }
}
