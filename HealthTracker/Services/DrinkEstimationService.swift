import Foundation

struct DrinkEstimationService {
    static func estimate(type: String, amountML: Double) -> (caffeine: Double, calories: Double) {
        let baseCaffeine: Double
        let baseCalories: Double

        switch type {
        case "ماء":
            baseCaffeine = 0
            baseCalories = 0
        case "قهوة":
            baseCaffeine = 90
            baseCalories = 5
        case "شاي":
            baseCaffeine = 40
            baseCalories = 2
        case "مشروب طاقة":
            baseCaffeine = 80
            baseCalories = 110
        case "مشروب غازي":
            baseCaffeine = 35
            baseCalories = 140
        default:
            baseCaffeine = 0
            baseCalories = 0
        }

        let ratio = amountML / 200.0
        return (baseCaffeine * ratio, baseCalories * ratio)
    }
}
