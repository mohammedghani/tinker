import Foundation
import CoreData

class TodayViewModel: ObservableObject {
    func totalsForFood(entries: [FoodEntry]) -> (calories: Double, protein: Double) {
        let today = Calendar.current.startOfDay(for: Date())
        let filtered = entries.filter { entry in
            guard let date = entry.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: today)
        }
        let calories = filtered.reduce(0) { $0 + $1.calories }
        let protein = filtered.reduce(0) { $0 + $1.protein }
        return (calories, protein)
    }

    func totalsForDrinks(entries: [DrinkEntry]) -> (water: Double, caffeine: Double, calories: Double) {
        let today = Calendar.current.startOfDay(for: Date())
        let filtered = entries.filter { entry in
            guard let date = entry.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: today)
        }
        let water = filtered.filter { $0.type == "ماء" }.reduce(0) { $0 + $1.amountML }
        let caffeine = filtered.reduce(0) { $0 + $1.estimatedCaffeineMG }
        let calories = filtered.reduce(0) { $0 + $1.estimatedCalories }
        return (water, caffeine, calories)
    }

    func latestSleep(entries: [SleepEntry]) -> SleepEntry? {
        entries.sorted { $0.wrappedEnd > $1.wrappedEnd }.first
    }

    func latestBowel(entries: [BowelEntry]) -> BowelEntry? {
        entries.sorted { $0.wrappedDate > $1.wrappedDate }.first
    }
}
