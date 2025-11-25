import Foundation
import CoreData

@objc(SleepEntry)
public class SleepEntry: NSManagedObject {
}

extension SleepEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepEntry> {
        NSFetchRequest<SleepEntry>(entityName: "SleepEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var durationHours: Double

    var wrappedStart: Date { startDate ?? Date() }
    var wrappedEnd: Date { endDate ?? Date() }
}

extension SleepEntry: Identifiable {}
