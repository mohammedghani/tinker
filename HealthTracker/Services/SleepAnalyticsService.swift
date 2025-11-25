import Foundation

struct SleepAnalyticsService {
    static func averageHours(last entries: [SleepEntry]) -> Double {
        guard !entries.isEmpty else { return 0 }
        let total = entries.reduce(0) { $0 + $1.durationHours }
        return total / Double(entries.count)
    }
}
