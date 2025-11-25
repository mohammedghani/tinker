import Foundation
import CoreData

@objc(BowelEntry)
public class BowelEntry: NSManagedObject {
}

extension BowelEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BowelEntry> {
        NSFetchRequest<BowelEntry>(entityName: "BowelEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var bristolType: Int16
    @NSManaged public var notes: String?
    @NSManaged public var painLevel: Int16

    var wrappedDate: Date { date ?? Date() }
}

extension BowelEntry: Identifiable {}
