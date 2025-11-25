import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        let sampleFood = FoodEntry(context: viewContext)
        sampleFood.id = UUID()
        sampleFood.date = Date()
        sampleFood.title = "فطور: بيض وخبز"
        sampleFood.notes = "مثال"
        sampleFood.calories = 220
        sampleFood.protein = 15
        sampleFood.carbs = 20
        sampleFood.fat = 10

        let drink = DrinkEntry(context: viewContext)
        drink.id = UUID()
        drink.date = Date()
        drink.type = "ماء"
        drink.amountML = 500
        drink.estimatedCalories = 0
        drink.estimatedCaffeineMG = 0

        let sleep = SleepEntry(context: viewContext)
        sleep.id = UUID()
        sleep.startDate = Date().addingTimeInterval(-8 * 3600)
        sleep.endDate = Date()
        sleep.durationHours = 8

        let bowel = BowelEntry(context: viewContext)
        bowel.id = UUID()
        bowel.date = Date()
        bowel.bristolType = 4
        bowel.notes = "مثال"
        bowel.painLevel = 1

        try? viewContext.save()
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = PersistenceController.createModel()
        container = NSPersistentContainer(name: "HealthTracker", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    private static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let food = NSEntityDescription()
        food.name = "FoodEntry"
        food.managedObjectClassName = NSStringFromClass(FoodEntry.self)
        food.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "title", type: .stringAttributeType),
            attribute(name: "notes", type: .stringAttributeType, optional: true),
            attribute(name: "photoData", type: .binaryDataAttributeType, optional: true),
            attribute(name: "calories", type: .doubleAttributeType),
            attribute(name: "protein", type: .doubleAttributeType),
            attribute(name: "carbs", type: .doubleAttributeType),
            attribute(name: "fat", type: .doubleAttributeType)
        ]

        let drink = NSEntityDescription()
        drink.name = "DrinkEntry"
        drink.managedObjectClassName = NSStringFromClass(DrinkEntry.self)
        drink.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "type", type: .stringAttributeType),
            attribute(name: "amountML", type: .doubleAttributeType),
            attribute(name: "estimatedCaffeineMG", type: .doubleAttributeType),
            attribute(name: "estimatedCalories", type: .doubleAttributeType)
        ]

        let sleep = NSEntityDescription()
        sleep.name = "SleepEntry"
        sleep.managedObjectClassName = NSStringFromClass(SleepEntry.self)
        sleep.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "startDate", type: .dateAttributeType),
            attribute(name: "endDate", type: .dateAttributeType),
            attribute(name: "durationHours", type: .doubleAttributeType)
        ]

        let bowel = NSEntityDescription()
        bowel.name = "BowelEntry"
        bowel.managedObjectClassName = NSStringFromClass(BowelEntry.self)
        bowel.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "bristolType", type: .integer16AttributeType),
            attribute(name: "notes", type: .stringAttributeType, optional: true),
            attribute(name: "painLevel", type: .integer16AttributeType)
        ]

        model.entities = [food, drink, sleep, bowel]
        return model
    }

    private static func attribute(name: String, type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = optional
        return attr
    }
}
