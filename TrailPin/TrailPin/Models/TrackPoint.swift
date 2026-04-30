import SwiftData
import Foundation

@Model
final class TrackPoint {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var speed: Double
    var accuracy: Double
    var timestamp: Date

    var track: Track?

    init(latitude: Double = 0, longitude: Double = 0, altitude: Double = 0,
         speed: Double = 0, accuracy: Double = 0, timestamp: Date = Date()) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.accuracy = accuracy
        self.timestamp = timestamp
    }
}
