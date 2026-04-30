import Foundation
import SwiftUI
import MapKit

@Observable
final class AppSettings {
    var useMiles: Bool {
        didSet { UserDefaults.standard.set(useMiles, forKey: "useMiles") }
    }

    var powerMode: PowerMode {
        didSet { UserDefaults.standard.set(powerMode.rawValue, forKey: "powerMode") }
    }

    var autoBatteryOptimize: Bool {
        didSet { UserDefaults.standard.set(autoBatteryOptimize, forKey: "autoBatteryOptimize") }
    }

    var mapStyle: MapStyleOption {
        didSet { UserDefaults.standard.set(mapStyle.rawValue, forKey: "mapStyle") }
    }

    enum PowerMode: String, CaseIterable {
        case performance = "Performance"
        case balanced = "Balanced"
        case ultraSaving = "Ultra Saving"

        var updateInterval: TimeInterval {
            switch self {
            case .performance: return 1.0
            case .balanced: return 5.0
            case .ultraSaving: return 30.0
            }
        }

        var distanceFilter: Double {
            switch self {
            case .performance: return 3.0
            case .balanced: return 10.0
            case .ultraSaving: return 50.0
            }
        }

        var estimatedBatteryHours: String {
            switch self {
            case .performance: return "4-6h"
            case .balanced: return "8-12h"
            case .ultraSaving: return "14-20h"
            }
        }

        var icon: String {
            switch self {
            case .performance: return "bolt.fill"
            case .balanced: return "battery.75"
            case .ultraSaving: return "leaf.fill"
            }
        }
    }

    enum MapStyleOption: String, CaseIterable {
        case standard = "Standard"
        case satellite = "Satellite"
        case hybrid = "Hybrid"

        var mapStyle: MapStyle {
            switch self {
            case .standard: return .standard
            case .satellite: return .imagery
            case .hybrid: return .hybrid
            }
        }

        var icon: String {
            switch self {
            case .standard: return "map"
            case .satellite: return "globe.americas"
            case .hybrid: return "map.fill"
            }
        }
    }

    init() {
        self.useMiles = UserDefaults.standard.object(forKey: "useMiles") as? Bool ?? true
        self.powerMode = PowerMode(rawValue: UserDefaults.standard.string(forKey: "powerMode") ?? "") ?? .balanced
        self.autoBatteryOptimize = UserDefaults.standard.object(forKey: "autoBatteryOptimize") as? Bool ?? true
        self.mapStyle = MapStyleOption(rawValue: UserDefaults.standard.string(forKey: "mapStyle") ?? "") ?? .standard
    }

    func formatDistance(_ meters: Double) -> String {
        if useMiles {
            return String(format: "%.2f mi", meters * 0.000621371)
        }
        return String(format: "%.2f km", meters / 1000)
    }

    func formatSpeed(_ metersPerSecond: Double) -> String {
        if useMiles {
            let mph = metersPerSecond * 2.23694
            return String(format: "%.1f mph", mph)
        }
        let kmh = metersPerSecond * 3.6
        return String(format: "%.1f km/h", kmh)
    }

    func formatAltitude(_ meters: Double) -> String {
        if useMiles {
            return String(format: "%.0f ft", meters * 3.28084)
        }
        return String(format: "%.0f m", meters)
    }
}
