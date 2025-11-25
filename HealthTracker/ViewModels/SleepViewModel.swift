import Foundation
import SwiftUI
import CoreData

class SleepViewModel: ObservableObject {
    @Published var startDate: Date = Calendar.current.date(byAdding: .hour, value: -8, to: Date()) ?? Date()
    @Published var endDate: Date = Date()
    @Published var duration: String = "8"

    func calculateDuration() {
        let diff = endDate.timeIntervalSince(startDate)
        let hours = max(diff / 3600, 0)
        duration = String(format: "%.1f", hours)
    }

    func save(context: NSManagedObjectContext) {
        calculateDuration()
        let entry = SleepEntry(context: context)
        entry.id = UUID()
        entry.startDate = startDate
        entry.endDate = endDate
        entry.durationHours = Double(duration) ?? 0
        try? context.save()
    }
}
