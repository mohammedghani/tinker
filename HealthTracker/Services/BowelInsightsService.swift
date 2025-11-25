import Foundation

struct BowelInsightResult {
    let status: String
    let hardPercentage: Double
    let loosePercentage: Double
    let suggestions: [String]
}

struct BowelInsightsService {
    static func analyze(entries: [BowelEntry]) -> BowelInsightResult {
        guard !entries.isEmpty else {
            return BowelInsightResult(status: "لا توجد بيانات كافية", hardPercentage: 0, loosePercentage: 0, suggestions: ["أضف سجلات جديدة لمتابعة حالتك."])
        }
        let hardCount = entries.filter { $0.bristolType <= 2 }.count
        let looseCount = entries.filter { $0.bristolType >= 5 }.count
        let total = Double(entries.count)
        let hardPercentage = Double(hardCount) / total * 100
        let loosePercentage = Double(looseCount) / total * 100

        let status: String
        var suggestions: [String] = []

        if hardPercentage > 50 {
            status = "إمساك / براز قاسٍ"
            suggestions = [
                "زد شرب الماء.",
                "أضف الألياف إلى طعامك (خضار، فواكه، حبوب كاملة).",
                "قلل من الكافيين إن كان زائدًا."
            ]
        } else if loosePercentage > 50 {
            status = "براز لين / إسهال"
            suggestions = [
                "راجع طعامك وتجنب الأطعمة المهيجة.",
                "استشر طبيبًا إذا استمرت الحالة.",
                "راقب الترطيب وتعويض السوائل."
            ]
        } else {
            status = "وضع البراز طبيعي"
            suggestions = ["استمر على روتينك الحالي."]
        }

        return BowelInsightResult(status: status, hardPercentage: hardPercentage, loosePercentage: loosePercentage, suggestions: suggestions)
    }
}
