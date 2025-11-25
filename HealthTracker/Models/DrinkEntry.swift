import Foundation
import CoreData

@objc(DrinkEntry)
public class DrinkEntry: NSManagedObject {
}

extension DrinkEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkEntry> {
        NSFetchRequest<DrinkEntry>(entityName: "DrinkEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var amountML: Double
    @NSManaged public var estimatedCaffeineMG: Double
    @NSManaged public var estimatedCalories: Double

    var wrappedDate: Date { date ?? Date() }
    var wrappedType: String { type ?? "" }
}

extension DrinkEntry: Identifiable {}
