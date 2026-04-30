import SwiftData
import Foundation

@Model
final class Track {
    var name: String
    var startDate: Date
    var endDate: Date?
    var distance: Double
    var duration: TimeInterval
    var pointCount: Int
    var activityType: String
    var colorHex: String

    @Relationship(deleteRule: .cascade, inverse: \TrackPoint.track)
    var points: [TrackPoint] = []

    @Relationship(deleteRule: .cascade, inverse: \Waypoint.track)
    var waypoints: [Waypoint] = []

    init(name: String = "", startDate: Date = Date(), endDate: Date? = nil,
         distance: Double = 0, duration: TimeInterval = 0,
         pointCount: Int = 0, activityType: String = "hiking",
         colorHex: String = "#52B788") {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.distance = distance
        self.duration = duration
        self.pointCount = pointCount
        self.activityType = activityType
        self.colorHex = colorHex
    }

    var formattedDistance: String {
        let useMiles = UserDefaults.standard.bool(forKey: "useMiles")
        if useMiles {
            return String(format: "%.2f mi", distance * 0.000621371)
        } else {
            return String(format: "%.2f km", distance / 1000)
        }
    }

    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        let seconds = Int(duration) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    var formattedPace: String {
        guard distance > 0 else { return "--:--" }
        let useMiles = UserDefaults.standard.bool(forKey: "useMiles")
        let unitDistance = useMiles ? distance * 0.000621371 : distance / 1000
        guard unitDistance > 0 else { return "--:--" }
        let paceSeconds = duration / unitDistance
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        let unit = useMiles ? "/mi" : "/km"
        return String(format: "%d:%02d %@", minutes, seconds, unit)
    }

    var activityIcon: String {
        switch activityType {
        case "hiking": return "figure.hiking"
        case "cycling": return "figure.outdoor.cycle"
        case "walking": return "figure.walk"
        case "running": return "figure.run"
        default: return "figure.hiking"
        }
    }
}
