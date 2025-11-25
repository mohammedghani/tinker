import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("الأهداف")) {
                    Stepper(value: $settings.waterGoal, in: 500...5000, step: 100) {
                        Text("هدف الماء: \(Int(settings.waterGoal)) مل")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Stepper(value: $settings.sleepGoal, in: 4...12, step: 0.5) {
                        Text("هدف النوم: \(String(format: "%.1f", settings.sleepGoal)) ساعات")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                Section(header: Text("خيارات")) {
                    Toggle("إظهار إحصاءات متقدمة", isOn: $settings.showAdvanced)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .navigationTitle("الإعدادات")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
