import SwiftData
import Foundation

@Model
final class Waypoint {
    var name: String
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var timestamp: Date
    var note: String

    var track: Track?

    init(name: String = "", latitude: Double = 0, longitude: Double = 0,
         altitude: Double = 0, timestamp: Date = Date(), note: String = "") {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.note = note
    }
}
