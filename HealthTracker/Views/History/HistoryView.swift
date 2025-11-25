import SwiftUI
import CoreData

struct HistoryView: View {
    @FetchRequest(entity: FoodEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: false)])
    private var foodEntries: FetchedResults<FoodEntry>
    @FetchRequest(entity: DrinkEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DrinkEntry.date, ascending: false)])
    private var drinkEntries: FetchedResults<DrinkEntry>
    @FetchRequest(entity: SleepEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SleepEntry.endDate, ascending: false)])
    private var sleepEntries: FetchedResults<SleepEntry>
    @FetchRequest(entity: BowelEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BowelEntry.date, ascending: false)])
    private var bowelEntries: FetchedResults<BowelEntry>

    var body: some View {
        NavigationStack {
            List {
                section(title: "وجبات") {
                    ForEach(foodEntries) { entry in
                        NavigationLink(destination: FoodDetailView(entry: entry)) {
                            VStack(alignment: .trailing) {
                                Text(entry.wrappedTitle)
                                Text(entry.wrappedDate, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                section(title: "مشروبات") {
                    ForEach(drinkEntries) { entry in
                        VStack(alignment: .trailing) {
                            Text("\(entry.wrappedType) - \(Int(entry.amountML)) مل")
                            Text(entry.wrappedDate, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                section(title: "النوم") {
                    ForEach(sleepEntries) { entry in
                        VStack(alignment: .trailing) {
                            Text("\(String(format: "%.1f", entry.durationHours)) ساعات")
                            Text(entry.wrappedEnd, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                section(title: "حركات الأمعاء") {
                    ForEach(bowelEntries) { entry in
                        VStack(alignment: .trailing) {
                            Text("نوع \(entry.bristolType)")
                            if let notes = entry.notes { Text(notes).font(.caption) }
                            Text(entry.wrappedDate, style: .date)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("السجل")
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        Section {
            content()
        } header: {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
