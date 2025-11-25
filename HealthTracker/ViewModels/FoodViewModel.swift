import Foundation
import SwiftUI
import CoreData

class FoodViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var notes: String = ""
    @Published var calories: Double = 0
    @Published var protein: Double = 0
    @Published var carbs: Double = 0
    @Published var fat: Double = 0
    @Published var photoData: Data?

    func estimateFromTitle() {
        let estimation = CalorieEstimationService.estimate(from: title)
        calories = estimation.calories
        protein = estimation.protein
        carbs = estimation.carbs
        fat = estimation.fat
    }

    func save(context: NSManagedObjectContext) {
        let entry = FoodEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.title = title
        entry.notes = notes
        entry.photoData = photoData
        entry.calories = calories
        entry.protein = protein
        entry.carbs = carbs
        entry.fat = fat
        try? context.save()
        reset()
    }

    func reset() {
        title = ""
        notes = ""
        calories = 0
        protein = 0
        carbs = 0
        fat = 0
        photoData = nil
    }
}
