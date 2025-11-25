import Foundation

struct MacroEstimation {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}

struct CalorieEstimationService {
    static func estimate(from text: String) -> MacroEstimation {
        let lowered = text.lowercased()
        var calories: Double = 200
        var protein: Double = 10
        var carbs: Double = 20
        var fat: Double = 8

        if lowered.contains("بيض") {
            let eggCount = extractNumber(from: lowered) ?? 2
            calories += Double(eggCount) * 70
            protein += Double(eggCount) * 6
            fat += Double(eggCount) * 5
        }
        if lowered.contains("رز") || lowered.contains("أرز") {
            calories += 200
            carbs += 40
        }
        if lowered.contains("خبز") {
            let slices = extractNumber(from: lowered) ?? 1
            calories += Double(slices) * 80
            carbs += Double(slices) * 15
        }
        if lowered.contains("دجاج") {
            calories += 180
            protein += 30
            fat += 5
        }
        if lowered.contains("لحم") {
            calories += 220
            protein += 25
            fat += 12
        }

        return MacroEstimation(calories: calories, protein: protein, carbs: carbs, fat: fat)
    }

    private static func extractNumber(from text: String) -> Int? {
        let digits = text.compactMap { $0.wholeNumberValue }
        if digits.isEmpty { return nil }
        return Int(digits.reduce(0) { $0 * 10 + $1 })
    }
}
