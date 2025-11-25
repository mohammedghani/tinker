import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("waterGoal") var waterGoal: Double = 2500
    @AppStorage("sleepGoal") var sleepGoal: Double = 7
    @AppStorage("showAdvanced") var showAdvanced: Bool = false
}
