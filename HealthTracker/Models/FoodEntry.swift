import Foundation
import CoreData

@objc(FoodEntry)
public class FoodEntry: NSManagedObject {
}

extension FoodEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntry> {
        return NSFetchRequest<FoodEntry>(entityName: "FoodEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var notes: String?
    @NSManaged public var photoData: Data?
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double

    var wrappedDate: Date { date ?? Date() }
    var wrappedTitle: String { title ?? "" }
}

extension FoodEntry: Identifiable {}
