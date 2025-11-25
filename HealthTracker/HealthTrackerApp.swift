import SwiftUI

@main
struct HealthTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("waterGoal") private var waterGoal: Double = 2500
    @AppStorage("sleepGoal") private var sleepGoal: Double = 7

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, Locale(identifier: "ar"))
                .environment(\.layoutDirection, .rightToLeft)
                .environmentObject(SettingsViewModel())
        }
    }
}
