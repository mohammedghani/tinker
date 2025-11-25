import Foundation
import SwiftUI
import CoreData

class BowelViewModel: ObservableObject {
    @Published var date: Date = Date()
    @Published var bristolType: Int = 4
    @Published var notes: String = ""
    @Published var pain: Int = 0

    func save(context: NSManagedObjectContext) {
        let entry = BowelEntry(context: context)
        entry.id = UUID()
        entry.date = date
        entry.bristolType = Int16(bristolType)
        entry.notes = notes.isEmpty ? nil : notes
        entry.painLevel = Int16(pain)
        try? context.save()
        reset()
    }

    func reset() {
        date = Date()
        bristolType = 4
        notes = ""
        pain = 0
    }
}
