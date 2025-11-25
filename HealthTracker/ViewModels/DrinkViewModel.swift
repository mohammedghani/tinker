import Foundation
import SwiftUI
import CoreData

class DrinkViewModel: ObservableObject {
    @Published var type: String = "ماء"
    @Published var amount: String = "250"
    @Published var caffeine: Double = 0
    @Published var calories: Double = 0

    func updateEstimates() {
        let amountValue = Double(amount) ?? 0
        let estimates = DrinkEstimationService.estimate(type: type, amountML: amountValue)
        caffeine = estimates.caffeine
        calories = estimates.calories
    }

    func save(context: NSManagedObjectContext) {
        updateEstimates()
        let entry = DrinkEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.type = type
        entry.amountML = Double(amount) ?? 0
        entry.estimatedCaffeineMG = caffeine
        entry.estimatedCalories = calories
        try? context.save()
        reset()
    }

    func reset() {
        type = "ماء"
        amount = "250"
        caffeine = 0
        calories = 0
    }
}
