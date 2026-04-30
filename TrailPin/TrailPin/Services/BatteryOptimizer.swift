import Foundation
import UIKit

@Observable
final class BatteryOptimizer {

    var currentMode: AppSettings.PowerMode = .balanced
    var batteryLevel: Float = 1.0
    var autoOptimize: Bool = true

    func updateBatteryLevel() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            batteryLevel = level
        }

        guard autoOptimize else { return }

        if batteryLevel < 0.1 {
            currentMode = .ultraSaving
        } else if batteryLevel < 0.3 {
            if currentMode == .performance {
                currentMode = .balanced
            }
        }
    }

    var batteryIcon: String {
        if batteryLevel >= 0.75 { return "battery.100" }
        if batteryLevel >= 0.5 { return "battery.75" }
        if batteryLevel >= 0.25 { return "battery.25" }
        return "battery.0"
    }

    var batteryColor: String {
        if batteryLevel >= 0.3 { return "green" }
        if batteryLevel >= 0.15 { return "yellow" }
        return "red"
    }
}
