import SwiftUI
import CoreData

struct InsightsView: View {
    @EnvironmentObject private var settings: SettingsViewModel
    @FetchRequest(entity: SleepEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SleepEntry.endDate, ascending: true)])
    private var sleepEntries: FetchedResults<SleepEntry>
    @FetchRequest(entity: BowelEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BowelEntry.date, ascending: true)])
    private var bowelEntries: FetchedResults<BowelEntry>

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sleepChart
                bowelInsightCard
            }
            .padding()
        }
        .navigationTitle("التحليلات")
    }

    private var sleepChart: some View {
        let recent = Array(sleepEntries.suffix(7))
        let maxValue = max(recent.map { $0.durationHours }.max() ?? 1, settings.sleepGoal)
        return VStack(alignment: .trailing, spacing: 12) {
            Text("النوم (آخر ٧ أيام)")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(recent.indices, id: \.self) { index in
                    let entry = recent[index]
                    let height = entry.durationHours / maxValue * 120
                    VStack {
                        Text(String(format: "%.1f", entry.durationHours))
                            .font(.caption)
                        Rectangle()
                            .fill(entry.durationHours >= settings.sleepGoal ? Color.green : Color.orange)
                            .frame(width: 20, height: height)
                        Text(shortDate(entry.wrappedEnd))
                            .font(.caption2)
                    }
                }
            }
            let average = SleepAnalyticsService.averageHours(last: recent)
            Text("المتوسط: \(String(format: "%.1f", average)) ساعات مقابل هدف \(String(format: "%.1f", settings.sleepGoal)) ساعات")
                .frame(maxWidth: .infinity, alignment: .trailing)
            if average < settings.sleepGoal {
                Text("متوسط النوم خلال الأيام الأخيرة أقل من الهدف. حاول زيادة عدد ساعات النوم.")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var bowelInsightCard: some View {
        let recent = Array(bowelEntries.suffix(7))
        let insight = BowelInsightsService.analyze(entries: recent)
        return VStack(alignment: .trailing, spacing: 8) {
            Text("حركات الأمعاء (آخر ٧ أيام)")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("\(String(format: "%.0f", insight.hardPercentage))٪ قاسٍ، \(String(format: "%.0f", insight.loosePercentage))٪ لين")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("الحالة: \(insight.status)")
                .frame(maxWidth: .infinity, alignment: .trailing)
            ForEach(insight.suggestions, id: \.self) { suggestion in
                HStack {
                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                    Text(suggestion)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = "d/M"
        return formatter.string(from: date)
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { InsightsView() }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(SettingsViewModel())
    }
}
