import SwiftUI
import CoreData
import UIKit

struct TodayView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var settings: SettingsViewModel
    @StateObject private var viewModel = TodayViewModel()

    @FetchRequest(entity: FoodEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: false)])
    private var foodEntries: FetchedResults<FoodEntry>
    @FetchRequest(entity: DrinkEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DrinkEntry.date, ascending: false)])
    private var drinkEntries: FetchedResults<DrinkEntry>
    @FetchRequest(entity: SleepEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SleepEntry.endDate, ascending: false)])
    private var sleepEntries: FetchedResults<SleepEntry>
    @FetchRequest(entity: BowelEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BowelEntry.date, ascending: false)])
    private var bowelEntries: FetchedResults<BowelEntry>

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                foodCard
                drinksCard
                sleepCard
                bowelCard
            }
            .padding()
        }
        .navigationTitle("اليوم")
    }

    private var foodCard: some View {
        let totals = viewModel.totalsForFood(entries: Array(foodEntries))
        return VStack(alignment: .trailing, spacing: 8) {
            Text("الطعام")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("إجمالي السعرات اليوم: \(Int(totals.calories))")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("إجمالي البروتين: \(Int(totals.protein)) غ")
                .frame(maxWidth: .infinity, alignment: .trailing)
            ForEach(foodEntries.filter { Calendar.current.isDate($0.wrappedDate, inSameDayAs: Date()) }) { entry in
                HStack {
                    if let data = entry.photoData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    VStack(alignment: .trailing) {
                        Text(entry.wrappedTitle)
                            .font(.headline)
                        Text("\(Int(entry.calories)) ك.س")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var drinksCard: some View {
        let totals = viewModel.totalsForDrinks(entries: Array(drinkEntries))
        let progress = min(totals.water / settings.waterGoal, 1.0)
        return VStack(alignment: .trailing, spacing: 8) {
            Text("المشروبات")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            VStack(alignment: .trailing) {
                Text("الماء: \(Int(totals.water))/\(Int(settings.waterGoal)) مل")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                ProgressView(value: progress)
                    .tint(.blue)
            }
            Text("الكافيين اليوم: \(Int(totals.caffeine)) ملغ")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("سعرات المشروبات: \(Int(totals.calories))")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var sleepCard: some View {
        let latest = viewModel.latestSleep(entries: Array(sleepEntries))
        let durationText: String
        if let latest {
            let hours = Int(latest.durationHours)
            let minutes = Int((latest.durationHours - Double(hours)) * 60)
            durationText = "آخر نوم: \(hours) ساعات و\(minutes) دقيقة"
        } else {
            durationText = "لا توجد بيانات"
        }

        return VStack(alignment: .trailing, spacing: 8) {
            Text("النوم")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(durationText)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var bowelCard: some View {
        let latest = viewModel.latestBowel(entries: Array(bowelEntries))
        let status: String
        if let latest {
            switch latest.bristolType {
            case 1,2: status = "براز قاسٍ"
            case 5,6,7: status = "براز لين"
            default: status = "طبيعي"
            }
        } else {
            status = "لا توجد بيانات"
        }
        return VStack(alignment: .trailing, spacing: 8) {
            Text("حركات الأمعاء")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            if let latest {
                Text("آخر نوع براز: \(latest.bristolType)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Text("الحالة العامة: \(status)")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { TodayView() }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(SettingsViewModel())
    }
}
