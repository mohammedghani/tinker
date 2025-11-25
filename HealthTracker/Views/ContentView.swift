import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("اليوم", systemImage: "sun.max.fill")
                }
            AddLogView()
                .tabItem {
                    Label("الإدخال", systemImage: "plus.circle")
                }
            HistoryView()
                .tabItem {
                    Label("السجل", systemImage: "clock.arrow.circlepath")
                }
            InsightsView()
                .tabItem {
                    Label("التحليلات", systemImage: "chart.bar.fill")
                }
            SettingsView()
                .tabItem {
                    Label("الإعدادات", systemImage: "gear")
                }
        }
        .accentColor(Color("AccentColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(SettingsViewModel())
    }
}
